defmodule LoadedBike.Web.UserView do
  use LoadedBike.Web, :view
  import Kerosene.HTML

  def avatar_img(user, size) do
    img_tag _avatar_url(user, size, LoadedBike.Web.AvatarUploader.url({user.avatar, user}, size))
  end

  defp _avatar_url(user, size, nil) do
    hash = Base.encode16(:erlang.md5(user.email), case: :lower)
    s = case size do
      :small  -> 32
      :tiny   -> 20
      _       -> 200
    end
    "https://www.gravatar.com/avatar/#{hash}?s=#{s}&d=retro"
  end
  defp _avatar_url(_user, _size, url), do: url
end