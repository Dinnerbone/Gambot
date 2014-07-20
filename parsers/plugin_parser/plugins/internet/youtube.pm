if ($message =~ /^${sl}${cm}youtube ([a-zA-Z0-9-_]+)(#[a-zA-Z0-9-_=]+)?$/i || $message =~ /^${sl}${cm}youtube [a-zA-Z0-9-_:\/\.&?=]*[?&]v=?([a-zA-Z0-9-_]+)[a-zA-Z0-9-_:\/\.&?=]*(#[a-zA-Z0-9-_=]+)?$/i) {
  require LWP::Simple;
  require LWP::UserAgent;
  my $vid = 'dQw4w9WgXcQ';
  my $anchor = '';
  $vid = $1 if $1;
  $anchor = $2 if $2;
  my $url = "http://gdata.youtube.com/feeds/api/videos/$vid?v=2";
  my $request = LWP::UserAgent->new;
  $request->timeout(60);
  $request->env_proxy;
  $request->agent('Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0)');
  $request->max_size('1024000');
  $request->parse_head(0);
  my $response = $request->get("$url");
  my $content = $response->decoded_content;

  if ($content =~ /<error><domain>GData<\/domain><code>InvalidRequestUriException<\/code><internalReason>Invalid id<\/internalReason><\/error>/) {
    actOut('MESSAGE',$target,"$receiver: That video does not exist.");
  }

  elsif ($content =~ /<title>(.+)<\/title>/) {
    my ($title, $uploader, $favorites, $views, $dislikes, $likes, $length, $length_m, $length_s, $restricted);
    $title = $1;
    $content =~ /<name>(.+)<\/name>/;
    $uploader = $1;
    $content =~ /<yt:statistics favoriteCount='([0-9]+)' viewCount='([0-9]+)'\/>/;
    ($favorites, $views) = ($1, $2);
    $content =~ /<yt:rating numDislikes='([0-9]+)' numLikes='([0-9]+)'\/>/;
    ($dislikes, $likes) = ($1, $2);
    $content =~ /<yt:duration seconds='([0-9]+)'\/>/;
    $length = $1;
    $length_m = int($length / 60);
    $length_s = $length % 60;
    $length_s = "0$length_s" if ($length_s =~ /^[0-9]$/);

    if ($content =~ /<media:restriction type='country'/) {
      $restricted = "(\x0307unavailable in some regions\x0F)";
    }
    else {
      $restricted = "(\x0314no region restrictions\x0F)";
    }

    if(eval {require HTML::Entities; 1;} == 1) {
      use HTML::Entities;
      $title = HTML::Entities::decode_entities($title);
    }

    actOut('MESSAGE',$target,"$receiver: \x02\"${title}\"\x02 Length: \x0306${length_m}${length_s}\x0F (by \x0303${uploader}\x0F) \x0314${views}\x0F views, \x0303${likes}\x0F likes, \x0304${dislikes}\x0F dislikes http://youtu.be/${vid}${anchor} ${restricted}");
  }
}
