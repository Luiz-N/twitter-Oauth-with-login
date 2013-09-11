get '/' do
  # @user = session[:user_id]
    # session.clear
  if current_user
    @current_user
    p @current_user
    erb :tweeter
  else
    erb :index
  # @user.fetch_tweets
  end

end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do

  if current_user
    erb :tweeter
  else
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  userHandle = @access_token.params[:screen_name]
  access_token = @access_token.token
  access_secret = @access_token.secret

  @current_user = User.find_or_create_by_username(username: userHandle, oauth_token: access_token, oauth_secret: access_secret)



  session[:user_id] = @current_user.id
  # session[:token] = @access_token.token
  # session[:secret] = @access_token.secret
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token
  erb :tweeter
  end
end


################ POST ##############################################

post '/grabTweets' do

  p params
  userhandle = params["user"]
  # p @user
  @current_user = User.find_by_username(userhandle)

  @user = Twitter::Client.new(
  :oauth_token => @current_user.oauth_token,
  :oauth_token_secret =>  @current_user.oauth_secret
  )

  @current_user.fetch_tweets(@user)
  @current_user.tweets.order('t_created_at DESC').to_json

  # @user.tweets.to_json

end




post '/tweet' do

  p params
  tweet = params["user"]
  user_handle = params["handle"]
  @user = User.find_by_username(user_handle)
  @user = Twitter::Client.new(
  :oauth_token => @user.oauth_token,
  :oauth_token_secret =>  @user.oauth_secret
  )
  @user.update(tweet)
# @user.fetch_tweets


end
