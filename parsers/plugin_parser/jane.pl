use strict;
use warnings;
use URI::Escape;
use FindBin;
use lib $FindBin::Bin;
use IRCParser;

$| = 1;

$IRCParser::permissions{'wesnoth/developer/*'}               = '#wesnoth*';
$IRCParser::permissions{'wesnoth/artist/*'}                  = '#wesnoth*';
$IRCParser::permissions{'wesnoth/forumsith/*'}               = '#wesnoth*';

$IRCParser::permissions{'wesnoth/developer/dave'}            = '#frogatto*';
$IRCParser::permissions{'wesnoth/developer/crimson_penguin'} = '#frogatto*';
$IRCParser::permissions{'wesnoth/artist/jetrel'}             = '#frogatto*';
$IRCParser::permissions{'unaffiliated/marcavis*'}            = '#frogatto*';

$IRCParser::permissions{'unaffiliated/dreadknight'}          = '#AncientBeast';

$IRCParser::permissions{'unaffiliated/aperson'}              = '#minecraft';
$IRCParser::permissions{'reddit/operator/bep'}               = '#minecraft';
$IRCParser::permissions{'unaffiliated/dagmar'}               = '#minecraft';
$IRCParser::permissions{'unaffiliated/helzibah'}             = '#minecraft';
$IRCParser::permissions{'reddit/operator/kylexy'}            = '#minecraft';
$IRCParser::permissions{'pdpc/supporter/student/phonicuk'}   = '#minecraft';
$IRCParser::permissions{'unaffiliated/skuld'}                = '#minecraft';
$IRCParser::permissions{'unaffiliated/streather'}            = '#minecraft';
$IRCParser::permissions{'i.could.have.had.any.host.but.i.decided.on.dinnerbone.com'} = '#minecraft';
$IRCParser::permissions{'unaffiliated/mustek'}               = '#minecraft';
$IRCParser::permissions{'unaffiliated/nikondork'}            = '#minecraft';
$IRCParser::permissions{'unaffiliated/ausmerica'}            = '#minecraft';
$IRCParser::permissions{'unaffiliated/forstride'}            = '#minecraft';
$IRCParser::permissions{'reddit/operator/mortvert'}          = '#minecraft';
$IRCParser::permissions{'defocus/yummy/enchilado'}           = '#minecraft';

$IRCParser::permissions{'unaffiliated/gambit/bot/*'}         = '##Gambot*';
$IRCParser::permissions{'unaffiliated/gambit/bot/*'}         = '#wesnoth-offtopic';
$IRCParser::permissions{'wesnoth/developer/grickit'}         = '*';
$IRCParser::permissions{'wesnoth/developer/shadowmaster*'}   = '*';

$IRCParser::sl = '';
$IRCParser::cm = '(?:&|(?:'.$IRCParser::botName.'[:,] ))';

# Autojoin list
if($IRCParser::pipeID eq 'fork10') {
  actOut('JOIN','##Gambot',undef);
  if($IRCParser::botName =~ /^janebot/) {
    actOut('JOIN','#wesnoth',undef);
    actOut('JOIN','#wesnoth-dev',undef);
    actOut('JOIN','##shadowm',undef);
    actOut('JOIN','#merc',undef);
    actOut('JOIN','#frogatto',undef);
    actOut('JOIN','#frogatto-dev',undef);
    actOut('JOIN','#unknown-horizons',undef);
    actOut('JOIN','#minecraft',undef);
    actOut('JOIN','#hosercraft',undef);
    actOut('JOIN','##Gambutt',undef);
    actOut('LITERAL',undef,'child_add>feed_timer>perl /home/gambit/source/Gambot/scripts/feed_timer.pl');
    actOut('LITERAL',undef,'child_add>streamtwitter>perl /home/gambit/source/Gambot/scripts/StreamReader/StreamTwitter.pl');
  }
}


sub on_server_ping {}
sub on_private_message {
  runPlugin("$FindBin::Bin/plugins/basic/ctcp.pm");
  on_public_message();
}
sub on_public_message {
  runPlugin("$FindBin::Bin/plugins/basic/about.pm");
  runPlugin("$FindBin::Bin/plugins/hug.pm");
  runPlugin("$FindBin::Bin/plugins/actions.pm");
  runPlugin("$FindBin::Bin/plugins/temperature.pm");
  runPlugin("$FindBin::Bin/plugins/time.pm");

  runPlugin("$FindBin::Bin/plugins/staff/joinpart.pm");
  runPlugin("$FindBin::Bin/plugins/staff/speak.pm");
  runPlugin("$FindBin::Bin/plugins/staff/op.pm");
  runPlugin("$FindBin::Bin/plugins/staff/voice.pm");
  runPlugin("$FindBin::Bin/plugins/staff/quiet.pm");
  runPlugin("$FindBin::Bin/plugins/staff/kick.pm");
  runPlugin("$FindBin::Bin/plugins/staff/ban.pm");

  runPlugin("$FindBin::Bin/plugins/conversation/ed-block.pm");
  runPlugin("$FindBin::Bin/plugins/conversation/memes.pm");
  runPlugin("$FindBin::Bin/plugins/conversation/quote.pm");
  #runPlugin("$FindBin::Bin/plugins/conversation/slurs.pm");

  runPlugin("$FindBin::Bin/plugins/games/roulette.pm");
  runPlugin("$FindBin::Bin/plugins/games/dice.pm");
  runPlugin("$FindBin::Bin/plugins/games/eightball.pm");
  runPlugin("$FindBin::Bin/plugins/games/buttcoins.pm");

  runPlugin("$FindBin::Bin/plugins/internet/url-check.pm");
  runPlugin("$FindBin::Bin/plugins/internet/ticket.pm");
  runPlugin("$FindBin::Bin/plugins/internet/youtube.pm");

  runPlugin("$FindBin::Bin/plugins_private/literal.pm");
  runPlugin("$FindBin::Bin/plugins_private/gitpull.pm");
  runPlugin("$FindBin::Bin/plugins/internet/QMarkAPI.pm");
}
sub on_private_notice {}
sub on_public_notice {}
sub on_join {}
sub on_part {}
sub on_quit {}
sub on_mode {
  runPlugin("$FindBin::Bin/plugins/staff/mode.pm");
}
sub on_nick {}
sub on_kick {}
sub on_topic {}
sub on_server_message {
  runPlugin("$FindBin::Bin/plugins/basic/nick_bump.pm");
}
sub on_server_error {}

# Fire the subroutine that is named in $event
&{\&{$IRCParser::event}}() if $IRCParser::event;
