$ ->
  if $("#leaderboard_placeholder").length > 0
    $.get
      url: "/challenges/list/"
      cache: false
      success: (html) ->
        $('#leaderboard_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#leaderboard_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
