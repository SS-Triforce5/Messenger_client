def relative_time(start_time)
  diff_seconds = (Time.now - Time.parse(start_time)).to_i
  case diff_seconds
    when 0
      'just now'
    when 1 .. 59
      "#{diff_seconds} seconds ago"
    when 60 .. (3600-1)
      "#{diff_seconds/60} minutes ago"
    when 3600 .. (3600*24-1)
      "#{diff_seconds/3600} hours ago"
    when (3600*24) .. (3600*24*30)
      "#{diff_seconds/(3600*24)} days ago"
    else
      start_time.strftime("%m/%d/%Y")
  end
end
