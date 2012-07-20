module CsvShaper
  
  # Row
  # Handles creating of cells within a row and
  # assigning of the model's values to cells
  # Examples:
  #   # pass a model to the row
  #   csv.row @model do |csv, model|
  #     ...
  #   end
  # 
  #   # create an empty row instance
  #   csv.row do |csv|
  #     ...
  #   end
  # 
  #   # create a row with prefilled cells from a model
  #   # note no block is passed
  #   csv.row @model, :name, :age, :location
  # 
  class Row < BlankSlate
    
    attr_accessor :model, :cells
    
    def initialize(*args)
      @cells = ActiveSupport::OrderedHash.new
      
      case
      # csv.row @user do |csv, user|
      when args.one? && block_given?
        @model = args.first
        yield self, @model
      
      # csv.row do |csv|
      when args.emtpy? && block_given?
        yield self
      
      # csv.row @user, :name, :age, :location
      when args.many?
        @model = args.pop
        args.each { |col| cell(col) }
      end        
    end
    
    # Public: assign the given Array of args to cells in this Row
    #
    #   args - Array of the arguments passed (expected to be Symbols)
    #
    # Returns an Array of the Cells in this row
    def cells(*args)
      args.each { |col| cell(col) }
      @cells
    end
    
    # Public: add a cell to this Row
    # If the Row has a @model defined passing just a Symbol will
    # call that method on the @model and assign it to a column of
    # the same name. Otherwise a value will need to be passed also
    #
    #   column - Symbol of the column to add to value to
    #   value - data to assign to the cell (default: nil)
    #
    # Returns an Array of the Row's cells
    def cell(column, value = nil)
      column = column.to_sym
      
      if @model && value.nil?
        @cells[column] = @model.send(column)
      else
        @cells[column] = value
      end
      
      @cells
    end
    
  end
end