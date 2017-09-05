const es = require("elasticsearch");
const fs = require("fs");
const readline = require('readline');
const stream = require('stream');

const client = new es.Client({
    host: "elastic:changeme@localhost:9200",
    log: "error",
});
const instream = fs.createReadStream("ratebeer.txt");
const outstream = new stream;
const rl = readline.createInterface(instream, outstream);
let review = {};
let reviews = [];

rl.on('line', function (line) {
    if (line === "") {
        reviews.push(review);
        review = {};
        if (reviews.length > 1000) {
            indexReviews(reviews);
            reviews = [];
        }
    } else {
        transformObject(review, line);
    }
});

rl.on('close', function () {
    console.log("done");
});

function transformObject(review, line) {
    const prop = line.substring(line.indexOf("/") + 1, line.indexOf(":")).trim();
    const val = line.substring(line.indexOf(":") + 1, line.length).trim();
    review[prop] = val;
    if (prop === "time") {
        review.date = new Date(val * 1000);
    }
}

function indexReviews(reviews) {
    const bulkarr = [];
    for (const review of reviews) {
        bulkarr.push({
            index: { _index: "reviews", _type: "review" }
        }, review);
    }

    client.bulk({
        body: bulkarr
    }, function (err, resp) {
        if (err) throw err;
        console.log(resp);
    });

}

