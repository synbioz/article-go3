require_relative 'quarto'
require_relative 'comm'
require_relative 'persistance'

require 'slim'
require 'sinatra'
require 'sinatra/reloader'

BUILDING = Building.new

get '/' do
  slim :index
end

post '/' do
  room = BUILDING.create_room
  room.selected_piece = rand(16)
  redirect("/room/#{room.key}")
end

get '/room/:key' do
  @room = BUILDING[params[:key]]
  redirect('/') if @room.nil?

  slim :room
end

post '/room/:key' do
  @room = BUILDING[params[:key]]
  redirect('/') if @room.nil?

  # Receive and play the user move
  move = Move.new(
    params[:i].to_i,
    params[:j].to_i,
    params[:k].to_i )

  if @room.valid_move?(move)
    @room.apply_move(move)

    # Ask the server for an opponent move and apply it
    msg      = Comm.build_message(@room.game, @room.selected_piece)
    response = Comm.send_message('localhost', 1234, msg)

    case response.shift
    when 0
      @room.won = :player
    when 1
      move = Move.new(*response)
      @room.apply_move(move)
    when 2
      move = Move.new(*response)
      @room.apply_move(move)
      @room.won = :computer
    end
  end

  slim :room
end
