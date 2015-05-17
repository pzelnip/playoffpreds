${main()}

<%def name="main()">
    ${top_base(rounds)}

    <div class="col-md-12">
        ${dump_rounds(rounds)}
        ${dump_score_summary(score_summary)}
    </div>


    ${bottom_base()}

    <div class="container">
        <div class="row">
            <a name="round42">
            <h2 class="roundTitle text-center">Round 42</h2>
            </a>
        </div>
        <div class="row drawborder">
            <div class="col-md-1 drawborder">&nbsp;</div>
            <div class="col-md-4 team drawborder">
                    <div class="pull-left hometeam">
                        My Teamsdaf asdf asdfa<br>
                        <img src="http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/anaheim-ducks.png" class="teamLogo img-responsive hometeamimg">
                    </div>
            </div>
            <div class="col-md-2 text-center lead">
                VS
            </div>
            <div class="col-md-4 team text-right drawborder">
                <div class="pull-right awayteam">
                    My other team<br>
                    <img src="http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/anaheim-ducks.png" class="teamLogo img-responsive awayteamimg">
                </div>
            </div>
            <div class="col-md-1 drawborder">&nbsp;</div>
        </div>
        <div class="row drawborder text-center">
            Tampa Bay Lightning in 6
        </div>
        <div class="row drawborder">
            <div class="col-md-2"> </div>
            <div class="pull-left col-md-4">
             Adam says New York Islanders in 6
            </div>
            <div class="pull-right col-md-4">
            (0 points for being totally wrong)
            </div>
            <div class="col-md-2"> </div>
        </div>
    </div>
</%def>

<%def name="top_base(rounds)">
    <html>
    <head>
        <link rel="stylesheet" type="text/css" href="static/nhl.css">
        <title>Playoff Predictions</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
    </head>
    <body>

    ${navbar_render(rounds)}

    <div class="container">
        <div class="jumbotron">
        <h2>Pedle's Family Playoff Predictions</h2>
        <p>Every year my wife & I make our NHL playoff predictions.  This year my 4 year old daughter joined in on the fun.  Below is the results</p>
        </div>
        <div class="row">
</%def>


<%def name="navbar_render(rounds)">
    <nav class="navbar navbar-inverse">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>                        
          </button>
          <a class="navbar-brand" href="#">PlayoffPreds</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Home</a></li>
            %for round in rounds:
                <li><a href="#round${round.number}">Round ${round.number}</a></li>
            %endfor
            <li><a href="#totals">Totals</a></li>
          </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="https://github.com/pzelnip/playoffpreds">
                <span class="glyphicon glyphicon-cutlery">
                </span> Fork Me On Github
                    </a></li>
          </ul>
        </div>
      </div>
    </nav>

</%def>

<%def name="bottom_base()">
        </div> <!-- class="row"> -->
        <br><br><br><br><br><br>
        <div class="text-center smalltext text-muted">
        <a href="http://www.sportsnet.ca/hockey/nhl/playoffs/">Sportsnet.ca NHL Playoffs</a>
         - 
        <a href="static/playoffs.json">View JSON</a>

    </div> <!-- container -->

    </body>
    </html>
</%def>

<%def name="dump_score_summary(score_summary)">
    <br><br><br>

    <a name="totals"></a>
    <div class="scoreSummary text-center">
        <h3 class="totalsHeading text-center">Totals</h3>

        %for round_score in score_summary.round_scores:
            ${dump_round_score(round_score)}
        %endfor

        <h2 class="text-center">Final Totals</h2>
        %for player_score in score_summary.final_score.scores:
            ${dump_prediction_score(player_score.name,
                player_score.score, 
                score_summary.final_score.possible,
                player_score.percent)}
        %endfor
    </div>
</%def>

<%def name="dump_round_score(round_score)">
    <h3 class="text-center">Round ${round_score.round_num}</h3>
    %for player_score in round_score.scores:
            ${dump_prediction_score(player_score.name, 
                player_score.score, round_score.possible, 
                player_score.percent)}
    %endfor
</%def>

<%def name="dump_prediction_score(name, score, possible, percent)">
    <div class="predictionScore">
        ${name} ${score} points (out of ${possible} possible, ${"%.0f" % percent}%)
    </div>
</%def>

<%def name="dump_rounds(rounds)">
    %for round in rounds:
        ${dump_round(round)}
    %endfor
</%def>

<%def name="dump_round(round)">
    <a name="round${round.number}">
    <h2 class="roundTitle text-center">Round ${round.number}</h2>
    </a>

    %for matchup in round.matchups:
        ${dump_matchup(matchup)}
    %endfor
</%def>

<%def name="dump_matchup(matchup)">
    <div class="matchup container">
        <div class="teamNames">
            <div class="team hometeam pull-left">
            ${matchup.home}<br>
            <img src="${matchup.homeimg}" class="teamLogo img-responsive">
            </div>
            <div class="vsCenter">
            Vs
            </div>
            <div class="team awayteam pull-right">
                ${matchup.away}<br>
                <img src="${matchup.awayimg}" class="teamLogo img-responsive">
            </div>
        </div>
        <div class="text-center result">${matchup.result}</div>

        <div class="predictionList">
            %for prediction in matchup.predictions:
                ${dump_prediction(prediction)}
            %endfor
        </div>
    </div>
    <br> <br> <br> <br> <br> <br>
</%def>

<%def name="dump_prediction(prediction)">
    <div class="prediction pull-left">
        ${prediction.predictor} says ${prediction.team} in ${prediction.games}
    </div>
    <div class="predictionResult pull-right">
        ${prediction.outcome}
    </div>
</%def>
