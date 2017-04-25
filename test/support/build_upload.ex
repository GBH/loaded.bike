defmodule LoadedBike.Web.Test.BuildUpload do

  def build_upload(args \\ []) do
    path          = Keyword.get(args, :path, "test/files/test.jpg")
    content_type  = Keyword.get(args, :content_type, "image/jpg")

    %{
      __struct__:   Plug.Upload,
      content_type: content_type,
      path:         path,
      filename:     Path.basename(path)
    }
  end

end