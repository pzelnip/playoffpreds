import json
from collections import defaultdict, namedtuple
from operator import itemgetter

from flask import Flask, jsonify
from flask.ext.mako import MakoTemplates
from flask.ext.mako import render_template


app = Flask(__name__)
mako = MakoTemplates(app)

Round = namedtuple('Round', ['number', 'matchups'])
Matchup = namedtuple('Matchup', ['home', 'homeimg', 'away', 'awayimg', 'result', 'predictions'])
Prediction = namedtuple('Prediction', ['predictor', 'team', 'games', 'outcome'])
RoundScore = namedtuple('RoundScore', ['round_num', 'scores', 'possible'])
ScoreResult = namedtuple('ScoreResult', ['name', 'score', 'percent'])
FinalScore = namedtuple('FinalScore', ['scores', 'possible'])
ScoreSummary = namedtuple('ScoreSummary', ['final_score', 'round_scores'])


POINTS_FOR_WINNING_TEAM = 2
POINTS_FOR_NUMBER_OF_GAMES = 1
POINTS_PER_SERIES = POINTS_FOR_WINNING_TEAM + POINTS_FOR_NUMBER_OF_GAMES


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
            points += POINTS_FOR_WINNING_TEAM
            picked_winner = True

        if pred['games'] == result['games']:
            points += POINTS_FOR_NUMBER_OF_GAMES
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


@app.route('/')
def index():
    return 'Flask is running<br><br><a href="/nhl">nhl predictions</a>'


def parse_data(rounds):
    round_counts = {}
    final_scores = {}
    round_results = []
    for round in rounds:
        round_number = round['round']

        scores = defaultdict(int)
        final_scores[round['round']] = scores

        round_count = 0
        matchups = []
        for series in round['roundPreds']:
            round_count += 1
            hometeam = series['hometeam']
            home_img = team_img(hometeam)
            awayteam = series['awayteam']
            away_img = team_img(awayteam)
            result = series.get('result', None)

            preds = []
            for prediction in series['predictions']:
                msg, score = pred_score(prediction, result)
                name = prediction['name']
                scores[name] += score

                preds.append(Prediction(name, prediction['team'], prediction['games'], msg))

            matchups.append(Matchup(hometeam, home_img, awayteam, away_img, fmt_result(result), preds))
        round_results.append(Round(round_number, matchups))
        round_counts[round['round']] = round_count

    round_scores_final = [] 
    for round_num, round_scores in final_scores.iteritems():
        possible = round_counts[round_num] * POINTS_PER_SERIES
        score_for_round = RoundScore(round_num, sorted([
                ScoreResult(name, score, float(score) / possible * 100)
                for name, score in round_scores.iteritems()
            ], key=itemgetter(2), reverse=True), possible)
        round_scores_final.append(score_for_round)

    total_possible = sum(round_counts.values()) * POINTS_PER_SERIES
    totals = defaultdict(int)
    for round in final_scores.values():
        for name, score in round.iteritems():
            totals[name] += score

    final_totals = sorted([
        ScoreResult(name, score, score * 1.0 / total_possible * 100)
        for name, score in totals.iteritems()], 
        key=itemgetter(2), reverse=True)

    final_scores = ScoreSummary(FinalScore(final_totals, total_possible), 
        round_scores_final)

    return round_results, final_scores


@app.route('/nhl')
def nhl():
    with open('static/playoffs.json', 'r') as fobj:
        content = "".join(fobj.readlines())
    rounds = json.loads(content)

    round_results, final_scores = parse_data(rounds)

    extra_vars = {
        'rounds' : round_results,
        'score_summary' : final_scores,
    }

    return render_template('nhl.mako', **extra_vars)

if __name__ == "__main__":
    app.run()
