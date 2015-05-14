import json
from collections import defaultdict
from flask import Flask, jsonify

app = Flask(__name__)

def team_img(team):
    imgmap = {
        "anaheim ducks" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/anaheim-ducks.png",
        "vancouver canucks" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/vancouver-canucks.png",
        "calgary flames" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/calgary-flames.png",
        "minnesota wild" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/minnesota-wild.png",
        "st louis blues" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/st-louis-blues.png",
        "chicago blackhawks" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/chicago-blackhawks.png",
        "nashville predators" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/nashville-predators.png",
        "winnipeg jets" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/winnipeg-jets.png",
        "ottawa senators" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/ottawa-senators.png",
        "montreal canadiens" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/montreal-canadiens.png",
        "detroit red wings" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/detroit-red-wings.png",
        "tampa bay lightning" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/tampa-bay-lightning.png",
        "pittsburgh penguins" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/pittsburgh-penguins.png",
        "new york rangers" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/new-york-rangers.png",
        "new york islanders" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/new-york-islanders.png",
        "washington capitals" : "http://www.sportsnet.ca/wp-content/themes/sportsnet-nhl/images/team_logos/200x200/hockey/nhl/washington-capitals.png",
    }
    return imgmap.get(team.lower(), 'http://upload.wikimedia.org/wikipedia/en/e/e4/NHL_Logo_former.svg')


def pred_score(pred, result):
    foo = ("...", 0)
    if result:
        points = 0
        picked_winner = False
        picked_games = False

        if pred['team'].lower() == result['team'].lower():
            points += 2
            picked_winner = True

        if pred['games'] == result['games']:
            points += 1
            picked_games = True
    
        if picked_winner and picked_games:
            msg = "a perfect prediction"
        elif picked_winner:
            msg = "picking winning team"
        elif picked_games:
            msg = "picking correct number of games"
        else:
            msg = "being totally wrong"

        msg = "(%s points for %s)" % (points, msg)
        foo = (msg, points) 
    return foo

def fmt_result(result):
    if result:
        return "%s in %s" % (result.get('team', ""), result.get('games'))
    else:
        return "Series in progress"

@app.route('/nhl')
def nhl2():
    with open('static/playoffs.json', 'r') as fobj:
        content = "".join(fobj.readlines())
    rounds = json.loads(content)

    output = """
<html>
<head>
	<link rel="stylesheet" type="text/css" href="static/nhl.css">
	<title>Playoff Preds</title>
</head>

<body>

""" 

    round_counts = {}
    final_scores = {}
    for round in rounds:
        scores = defaultdict(int)
        final_scores[round['round']] = scores
        output += """
<h2 class="roundTitle">Round %s</h2>""" % round['round']

        round_count = 0
        for series in round['roundPreds']:
            round_count += 1
            result = series.get('result', None)
            output += """
    <div class="matchup">
    	<div class="teamNames">
    		<div class="team hometeam">
            %s<br>
            <img src="%s" class="teamLogo">
    		</div>
    		<div class="vsCenter">
    		Vs
    		</div>
    		<div class="team awayteam">
    			%s<br>
                <img src="%s" class="teamLogo">
    		</div>
    	</div>
    """ % (series['hometeam'], team_img(series['hometeam']), series['awayteam'], team_img(series['awayteam']))

            output += """
    	<div class="result">%s</div>
        <div class="predictionList">
            """ % fmt_result(result)
     
            for prediction in series['predictions']:
                msg, score = pred_score(prediction, result)
                name = prediction['name']
                scores[name] += score

                output += """
    		<div class="prediction">
                %s says %s in %s
            </div>
    		<div class="predictionResult">
    			%s
    		</div>
                """ % (name, prediction['team'], prediction['games'], msg)

            output += """
    	</div>
    </div>
    <br> <br> <br> <br> <br> <br>
            """

            output += "\n"
        round_counts[round['round']] = round_count
    output += """
<br><br><br>

<div class="scoreSummary">
<span class="totalsHeading">Totals</span>
"""
    
    for round_num, round_scores in final_scores.iteritems():
        output += """
    <h3 style="text-align: center;">Round %s</h3>
        """ % round_num
        possible = round_counts.get(round_num, 0) * 3
        for name, score in round_scores.iteritems():
            output += format_pred_score_line(name, score, possible)
#            """
#        <div class="predictionScore">%s %s points (out of %s possible, %.0f%%)</div>
#            """ % (name, score, possible, (score * 100.0/ possible))

    totals = defaultdict(int)
    for round in final_scores.values():
        for name, score in round.iteritems():
            totals[name] += score

    total_possible = sum(map(lambda x: x * 3, round_counts.values()))
    output += """<h2 style="text-align: center;">Final Totals</h3>"""
    for name, score in totals.iteritems():
            output += format_pred_score_line(name, score, total_possible)
#            """
#        <div class="predictionScore">%s %s points (out of %s possible)</div>
#            """ % (name, score, total_possible)
    output += """
</div>

<div class="centerblock">
<a href="http://www.sportsnet.ca/hockey/nhl/playoffs/">Sportsnet.ca NHL Playoffs</a>

</body>
</html>
    """
    return output

def format_pred_score_line(name, score, possible):
    return """
<div class="predictionScore">%s %s points (out of %s possible, %.0f%%)</div>
        """ % (name, score, possible, (score * 100.0/ possible))



@app.route('/nhlold')
def nhl():

    with open('static/playoffs.json', 'r') as fobj:
        content = "".join(fobj.readlines())
    rounds = json.loads(content)

    output = "<pre>\n"

    scores = defaultdict(int)
    for series in preds:
        result = series.get('result', None)
        output += "%s vs %s\n" % (series['hometeam'], series['awayteam'])
        if result:
            output += "%s win in %s games\n" % (result['team'], result['games'])
        else:
            output += "--series in progress--\n"
        for prediction in series['predictions']:
            msg, score = pred_score(prediction, result)
            name = prediction['name']
            scores[name] += score
            output += "%s says %s in %s %s\n" % (name, prediction['team'], prediction['games'], msg)
        output += "-" * 20
        output += "\n"

    for k, v in scores.iteritems():
        output += "%s - %s points\n" % (k, v)

    output += "</pre>\n"
    return output

@app.route('/')
def index():
    return 'Flask is running<br><br><a href="/nhl">nhl predictions</a>'

@app.route('/data')
def names():
    data = {"names": ['John', "jacob", "Julie", "Jennifer", "julie"]}
    return jsonify(data)

if __name__ == "__main__":
    app.run()

