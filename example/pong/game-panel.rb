require_relative '../../crimson'
require_relative 'user-manager'

class GameSearchPanel < Crimson::Widget
  def initialize(user, parent: app.root)
    super(parent: parent)
    self.css_class += [:"text-center"]

    @user = user

    @searching = false
    @search_btn = Button "Search" do
      set :onclick, 'this.blur();' # remove the border
      self.css_class += [:"btn", :"btn-primary"]
      self.style = {
        'margin': '30px 30px 30px 30px',
        'width': '100px',
      }
    end

    @search_btn.on(:click) do |meta|
      @searching = !@searching
      if @searching
        @search_btn.text = "Stop"
        @search_btn.css_class = @search_btn.css_class.map { |cls| cls == :'btn-primary' ? :'btn-danger' : cls }
      else
        @search_btn.text = "Search"
        @search_btn.css_class = @search_btn.css_class.map { |cls| cls == :'btn-danger' ? :'btn-primary' : cls }
      end
    end
  end
end

class HighscorePanel < Crimson::Table
  def initialize(parent: app.root)
    super(parent: parent)
    self.css_class += [:"table", :"table-hover"]

    THead do 
      self.css_class += [:"thead-light"]
      Row do
        ColumnHead() { Text("User") }
        ColumnHead() { Text("W") }
        ColumnHead() { Text("L") }
        ColumnHead() { Text("T") }
      end
    end
    
    TBody do
      UserManager.instance.each_user do |user|
        Row do
          Column() { Text(user.name) }
          Column() { Text(user.wins) }
          Column() { Text(user.losses) }
          Column() { Text(user.wins - user.losses) }
        end
      end
    end
  end
end

class GamePanel < Crimson::Widget
  def initialize(user, parent: app.root)
    super(parent: parent)

    self.css_class += [:"card"] 
    self.style = {
      'margin': '10px 10px 10px 10px',
      'max-width': '400px',
      'height': '95vh'
    }

    @user = user
    H5("Game Search") { self.css_class += [:"card-header", :"bg-primary", :"text-white"] }
    @game_search = GameSearchPanel(user) {}
    
    H5("Highscore") { self.css_class += [:"card-header", :"bg-primary", :"text-white"] }
    @highscore = HighscorePanel() {}
    container = Widget() { self.style = { "overflow-y": "auto" } }
    @highscore.bond(container)
  end
end