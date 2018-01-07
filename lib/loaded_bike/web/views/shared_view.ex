defmodule LoadedBike.Web.SharedView do
  use LoadedBike.Web, :view

  def disqus(url: url, id: id) do
    content_tag(:div, class: "comments") do
      [
        content_tag(:div, "", id: "disqus_thread"),
        content_tag :script do
          raw """
          var disqus_config = function () {
            this.page.url         = "#{url}";
            this.page.identifier  = "#{id}";
          };
          (function() {
            var d = document, s = d.createElement('script');
            s.src = 'https://loaded-bike.disqus.com/embed.js';
            s.setAttribute('data-timestamp', +new Date());
            (d.head || d.body).appendChild(s);
          })();
          """
        end
      ]
    end
  end
end
