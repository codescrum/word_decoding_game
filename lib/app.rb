require_relative '../config/boot'
require_relative './encoder'
require_relative './random_generator'

require 'sinatra/base'
require 'sinatra/reloader'
require 'active_support/all'

class StringEncoderGameServer < Sinatra::Base

  attr_accessor :requests
  attr_accessor :encoder

  attr_accessor :word_list

  attr_accessor :sessions

  # Enable sinatra reloader
  configure :development do
    register Sinatra::Reloader
    also_reload File.expand_path('../encoder.rb', __FILE__)
    also_reload File.expand_path('../random_generator.rb', __FILE__)
  end

  # Admit connections from anyone
  set :bind, '0.0.0.0'

  def initialize
    # initialize an encoder
    @encoder = Encoder.new

    # initialize empty words list
    @word_list = []

    # Initialize the words list to have in memory
    words_file = File.expand_path('../../config/dictionaries/words-es.txt', __FILE__)
    File.foreach(words_file).map{|word| @word_list.push(word)}

    # initialize empty sessions hash, key will be the ip
    @sessions = {}

    super
  end

  # Super endpoint
  get '/word' do
    ip = request.ip.to_s
    session = sessions[ip]
    if session
      word = new_word
      session[:challenge][:original_word] = word
      session[:challenge][:encoded_word] = encoded_word_for_challenge(session[:current_challenge], word)
      session[:challenge][:encoded_word]
    else
      word = new_word
      create_session(ip, word)
      word
    end
  end

  get '/answer' do
    ip = request.ip.to_s
    session = get_session(ip)

    if session
      # encoded_word = params[:encoded_word].strip
      answer = params[:answer].strip

      challenge = session[:challenge]

      challenge[:original_word]

      if challenge[:ends_at] > Time.now
        return "Your time has ended, please request a new word at /word"
      else
        if answer == challenge[:original_word]
          # increment challenge
          session[:current_challenge] = session[:current_challenge] + 1
          return "OK! - You have succesfully completed this challenge, please ask for another word to see the next challenge"
        else
          "SORRY - the answer is invalid, please try again"
        end
      end

    else
      "You have to request a word first!"
    end
  end

  def new_word
    word_list.select{|word| word.length > 4 }.sample.strip
  end

  def create_session(ip, original_word)
    sessions[ip] = {current_challenge: 1, challenge: { original_word: original_word, encoded_word: encoder.noop(original_word), ends_at: (Time.now + 500.seconds)}}
  end

  def get_session(ip)
    sessions[ip]
  end

  def new_word_for(session)
    challenge = session[:current_challenge]
    word = new_word
    encoded_word = ''
    encoded_word = encoded_word_for_challenge(challenge, word)
  end

  def encoded_word_for_challenge(challenge_number, word)
    case challenge_number
    when 1
      encoded_word = encoder.noop(word)
    when 2
      encoded_word = encoder.reverse(word)
    when 3
      encoded_word = encoder.vowels_to_numbers(word)
    when 4
      encoded_word = encoder.rotate(word, 3)
    when 5
      encoded_word = encoder.vowel_obfuscate(word)
    when 6
      encoded_word = encoder.caesar_encode(word, 5)
    else
      encoded_word = encoder.noop(word)
    end
  end

end
