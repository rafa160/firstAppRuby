class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Cadastro de Moedas"
  end
end
