defmodule LoadedBike.Web.SharedView do
  use LoadedBike.Web, :view

  def disqus(conn, tour = %LoadedBike.Tour{}) do
    draw_disqus(
      conn,
      user: tour.user,
      id:   tour.id,
      url:  tour_url(conn, :show, tour.id)
    )
  end

  def disqus(conn, waypoint = %LoadedBike.Waypoint{}) do
    tour = waypoint.tour
    draw_disqus(
      conn,
      user: tour.user,
      id: "#{tour.id}.#{waypoint.id}",
      url: tour_waypoint_url(conn, :show, tour.id, waypoint.id)
    )
  end

  defp draw_disqus(conn, user: user, id: id, url: url) do
    content_tag(:div, class: "comments") do
      [
        content_tag(:div, "", id: "disqus_thread"),
        content_tag :script do
          raw """
          var disqus_config = function () {
            this.page.identifier  = "#{id}";
            this.page.url         = "#{url}";
            this.callbacks.onNewComment = [function(comment){
              UJS.xhr("#{user_comment_callback_path(conn, :comment_callback, user)}", "POST", {
                type: "json",
                data: {
                  url:      "#{url}",
                  comment:  comment.text
                }
              })
            }];
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
