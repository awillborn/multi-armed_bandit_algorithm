helpers do
  def init_redis
    $redis.setnx "show:pink", 1
    $redis.setnx "show:blue", 1
    $redis.setnx "show:green", 1
    $redis.setnx "click:pink", 1
    $redis.setnx "click:blue", 1
    $redis.setnx "click:green", 1
    $redis.setnx "wins:pink", 1
    $redis.setnx "wins:blue", 1
    $redis.setnx "wins:green", 1
  end

  def select_color
    if rand < 0.5
      color = ["pink", "green", "blue"].sample
    else
      color = fetch_best_color
    end
    update_show_count(color)
    color
  end

  def update_show_count(color)
    current_show_count = $redis.get "show:#{color}"
    $redis.set "show:#{color}", current_show_count.to_i + 1
  end

  def update_win_percentage(color)
    click_count = $redis.get("click:#{color}").to_i
    show_count = $redis.get("show:#{color}").to_i
    $redis.set "wins:#{color}", ((click_count.to_f/show_count.to_f) * 100).round(2)
  end

  def update_click_count(color)
    new_click_count = $redis.get("click:#{color}").to_i + 1
    $redis.set "click:#{color}", new_click_count
  end

  def fetch_best_color
    wins = [$redis.get("wins:pink"), $redis.get("wins:blue"), $redis.get("wins:green")]
    max_wins = wins.max

    possible_winners = []
    possible_winners << "pink" if $redis.get("wins:pink") == max_wins
    possible_winners << "blue" if $redis.get("wins:blue") == max_wins
    possible_winners << "green" if $redis.get("wins:green") == max_wins

    possible_winners.sample
  end

  def get_click_show_vars
    @pink_show = $redis.get "show:pink"
    @pink_click = $redis.get "click:pink"
    @pink_wins = $redis.get "wins:pink"
    @blue_show = $redis.get "show:blue"
    @blue_click = $redis.get "click:blue"
    @blue_wins = $redis.get "wins:blue"
    @green_show = $redis.get "show:green"
    @green_click = $redis.get "click:green"
    @green_wins = $redis.get "wins:green"
  end
end

get '/' do
  init_redis
  @winning_color = select_color
  update_win_percentage(@winning_color)
  get_click_show_vars
  haml :index
end

post '/add_click' do
  color = params[:color]
  update_click_count(color)
end

post '/reset_db' do
  $redis.flushdb
end

