defmodule LoadedBike.Web.UserView do
  use LoadedBike.Web, :view

  def avatar_img(user, size) do
    img_tag _avatar_url(user, size, LoadedBike.Web.AvatarUploader.url({user.avatar, user}, size))
  end

  defp _avatar_url(user, size, nil) do
    hash = Base.encode16(:erlang.md5(user.email), case: :lower)
    s = case size do
      :small  -> 32
      :tiny   -> 20
    end
    "https://www.gravatar.com/avatar/#{hash}?s=#{s}"
  end
  defp _avatar_url(user, size, url), do: url
end