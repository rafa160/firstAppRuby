namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") do
        %x(rails db:drop)
      end

      show_spinner("Criando DB...") do
        %x(rails db:create)
      end

      show_spinner("Criando Migração...") do
        %x(rails db:migrate)
      end

      # metodo populo os tipos de mineração
      %x(rails dev:add_types)

      #metodo especifico que popula, não usando mais o db:seed
      %x(rails dev:add_coins)
    else
      puts "Você não está no modo de desenvolvimento"
    end
  end

  private

  def show_spinner(start_msg, end_msg = "Conluído")
    spinner = TTY::Spinner.new("[:spinner] #{start_msg}...", format: :pulse_2)
    spinner.auto_spin
    yield
    spinner.success("#{end_msg}")
  end

  desc "Cadastra Moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando Moedas...") do
      coins = [
          {
              description: "Bitcoin",
              acronym: "BTC",
              url_img: "https://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png",
              mining_type: MiningType.find_by(acronym: 'PoW')
          },
          {
              description: "Ethereum",
              acronym: "ETC",
              url_img: "https://cdn.iconscout.com/icon/free/png-256/ethereum-7-645810.png",
              mining_type: MiningType.all.sample
          },
          {
              description: "Dash",
              acronym: "DASH",
              url_img: "https://s2.coinmarketcap.com/static/img/coins/200x200/131.png",
              mining_type: MiningType.all.sample
          }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastro dos Tipos de mineração"
  task add_types: :environment do
    show_spinner("Cadastrando Tipos de Minerção...") do
      types = [
          {
              description: "Proof of Work",
              acronym: "PoW"
          },
          {
              description: "Proof of Stake",
              acronym: "PoS"
          },
          {
              description: "Proof of Capacity",
              acronym: "PoC"
          }
      ]

      types.each do |types|
        MiningType.find_or_create_by!(types)
      end
    end
  end
end
