defmodule TttWeb.Router do
  use TttWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TttWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/game", GameController, :index
    post "/game", GameController, :update
  end

end
