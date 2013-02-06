# coding: utf-8

# Command is the main point of entry for looper commands; shell arguments are
# passd through to Command, which then filters and parses through individual
# commands and reroutes them to constituent object classes.
#
# Command also keeps track of one connection to Storage, which is how new data
# changes are persisted to disk. It takes care of any data changes by calling
# Looper::Command#save.
#

module Looper
  class Command
    class << self
      include Looper::Color

      # Public: accesses the in-memory JSON representation.
      #
      # Returns a Storage instance.
      def storage
        Looper.storage
      end

      # Public: crawls the given directoy and then searches for files
      #          matching the file extension. default extension is ".c"
      #
      # dir    - directory path to crawl
      # ext    - file extension
      #
      # Returns an array of items to be added to a list
      def find(dir, ext = ".c")
        files = []

        # copy file and path to array if filename ends in ext. e.g., ".c"
        Find.find(dir) do |f|
          files << f if f.match(/\.#{ext}\Z/)
        end

        files
      end

      def fix(files)
        # filename      = this
        # while-loop    = 5
        # datatypes     = [this, that, those, these]
        # predicate     = 'a + 2 > 10'
        #

        items     = []

        files.each do |file|

          source = File.read(file)
          ast    = C.parse(source)

          ast.entities.each do |declaration|
            # get all while loops in file
            declaration.statement.each do |stmt|
              unless stmt.type.While?
                items << Item.new(stmt.name, stmt.type)
              end
            end
          end
        end
      end

      # Public: snoops a given directory path and creates a list file.
      def snoop(dir, lst)
        # find all files
        # inspect each file

        files = find(dir)


        files.each do |file|
          create_list(lst << 'bind')

        end
      end

      # Public: add a new Project.
      #
      # name  - the String name of the Project.
      # item  - the String name of the Item
      # value - the String value of Item
      #
      # Example
      #
      #   Commands.list_create("snippets")
      #   Commands.list_create("hotness", "item", "value")
      #
      # Returns the newly created Project and creates an item when asked.
      def create_list(name, item = nil, value = nil)
        lists = (storage.lists << Project.new(name))
        storage.lists = lists
        output "#{cyan("Looper!")} Created a new list called #{yellow(name)}."
        save
        add_item(name, item, value) unless value.nil?
      end

      # Public: executes a command.
      #
      # args    - The actual commands to operate on. Can be as few as zero
      #           arguments or as many as three.
      def execute(*args)
        command = args.shift
        major   = args.shift
        minor   = args.empty? ? nil : args.join(' ')

        return overview unless command
        delegate(command, major, minor)
      end


      # Public: prints any given string.
      #
      # s = String output
      #
      # Prints to STDOUT and returns. This method exists to standardize output
      # and for easy mocking or overriding.
      def output(s)
        puts(s)
      end



      # Public: gets $stdin.
      #
      # Returns the $stdin object. This method exists to help with easy mocking
      # or overriding
      def stdin
        $stdin
      end

      #  Public: allows main access to most commands.
      #
      #  Returns output based on method calls.
      def delegate(command, major, minor)
        return all               if command == 'all'
        return edit              if command == 'edit'
        return show_storage      if command == 'storage'
        return version           if command == "-v"
        return version           if command == "--version"
        return help              if command == 'help'
        return help              if command[0] == 45 || command[0] == '-' # any - dash options are pleas for help
        return echo(major,minor) if command == 'echo' || command == 'e'
        return open(major,minor) if command == 'open' || command == 'o'

        # if we're operating on a Project
        if storage.list_exists?(command)

        end
      end


      # Public: prints a tidy overview of your Projects in descending order of
      # number of Items.
      #
      # Returns nothing.
      def overview
        storage.lists.each do |list|
          output "  #{list.name} (#{list.items.size})"
        end

        s =  "You don't have anything yet! To start out, create a new project:"
        s << "\n  $ looper <project-name>"
        s << "\nAnd then assigns a new source to your project!"
        s << "\n  $ looper <project-name> src <value>"
        s << "\nYou can then take a peek at project:"
        s << "\n  $ looper <project-name> peek"
        output s if storage.lists.size == 0
      end

      # Public: search for an Item in a particular project by name. Drops the
      # corresponding entry into your clipboard if found.
      #
      # project_name - the String name of the project in which to scope the search
      # item_name    - the String term to search for in all Item names
      #
      # Returns the matching Item if found.
      def search_project_for_item(project_name, item_name)
        list = Project.find(project_name)
        item = list.find_item(item_name)

        if item
          output "#{cyan("Looper!")} We just copied #{yellow(Platform.copy(item))} to your clipboard."
        else
          output "#{yellow(item_name)} #{red("not found in")} #{yellow(list_name)}"
        end

        # Public: save in-memory data to disk.
        #
        # Returns whether or not data was saved.
        def save
          storage.save
        end


        # Public: the version of looper that you're currently running.
        #
        # Returns a String identifying the version number.
        def version
          output "You're running looper #{Looper::VERSION}. Congratulations!"
        end


        # Public: launches JSON file in an editor for you to edit manually.
        #
        # Returns nothing.
        def edit
          if storage.respond_to?("json_file")
            output "#{cyan("Looper!")} #{Platform.edit(storage.json_file)}"
          else
            output "This storage backend does not store #{cyan("Looper!")} data on your computer"
          end
        end


        # Public: prints all the commands of looper.
        #
        # Returns nothing.
        def help
          text = %{
          - looper: help ---------------------------------------------------

          looper                            ;display high-level overview
          looper all                        ;show all items in all lists
          looper edit                       ;edit the looper JSON file in $EDITOR
          looper help                       ;this help text
          looper storage                    ;shows which storage backend you're using

          looper <project>                  ;create a new project
          looper <project>                  ;show items for a project
          looper <project> delete           ;deletes a project
          looper <project> src <value>      ;assigns a new source for a project
          looper <project> peek             ;take a peek at project

          looper <project> <name> open      ;open all item's content in in $EDITOR for a project
          looper <project> <name> delete    ;deletes an item in a project
          looper <project> <name>           ;copy item's value to clipboard

          all other documentation is located at:
            https://github.com/hsanchez/looper
        }.gsub(/^ {8}/, '') # strip the first eight spaces of every line

          output text

        end


    end
  end
end
end