class Item < Sinatra::Application

  before do
    @user = App.get_user_by_name(session[:name])
  end

  get "/items" do
    redirect '/login' unless session[:name]

    haml :items, :locals => { :current_user => @user }
  end

  post "/act_deact/:item_id/:activate" do
    redirect '/login' unless session[:name]

    activate_str = params[:activate]
    activate = (activate_str == "true")

    item = App.get_item_by_id(Integer(params[:item_id]))
    item.active = activate

    redirect back
  end

  post "/delete_item/:item_id" do
    item_id = Integer(params[:item_id])
    item = App.get_item_by_id(item_id)
    App.delete_item(item)

    redirect back
  end

  post "/create_item" do
    redirect back if params[:item_name] == "" or params[:item_price] == ""

    item_name = params[:item_name]
    item_price = Integer(params[:item_price])

    item = @user.propose_item(item_name, item_price)
    App.add_item(item)

    redirect back
  end
end