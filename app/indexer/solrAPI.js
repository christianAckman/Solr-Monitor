// https://github.com/godong9/solr-node

// Require module
var SolrNode = require('solr-node');

// Create solr client
function getClient(solrConfig){
    logFunc(getClient);
    try{
        let ss = new SolrNode(solrConfig);
        return ss;
    }
    catch(e){
        console.log('couldnt create client: ' + e)
    }
}

function logFunc(func){
    console.log(func.name);
}


// JSON Data
// var data = {
//     text: 'test',
//     title: 'test'
// };
function index(client, data){

    // Update document to Solr server
    client.update(data, function(err, result) {
        if (err) {
            console.log('err: ' + err);
            return;
        }
        else{
            console.log('success ', result.responseHeader);
            console.log('status: ' + result.responseHeader.status)
        }
    });
}

function commit(client){
    client.commit(function(err, result){
        if (err) {
            console.log('err: ' + err);
            return;
        }
        else{
            console.log('success ', result.responseHeader);
            console.log('status: ' + result.responseHeader.status)
        }
    })
}

// {text:'test', title:'test'}
function query(client, query){

    var query = client.query().q(query);
                        //     .addParams({
                        //         wt: 'json',
                        //         indent: true
                        //     })
                        //     .start(1)
                        //     .rows(1);

    client.search(query, function (err, result){
        if(err){
            console.log('err: ' + err);
            return;
        }
        else{
            console.log('success ', result.response);
        }
    })
}


module.exports = {
    getClient: getClient,
    index: index,
    commit: commit,
    query: query
}