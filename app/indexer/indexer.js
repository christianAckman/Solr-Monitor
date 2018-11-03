const solrAPI = require('./solrAPI.js');
// const args = require('minimist')(process.argv.slice(2));
const faker = require('faker');
var request = require('request-promise');

let solr = ''

let solrConfig = {
    host: 'solr',
    port: '8983',
    core: 'population',
    protocol: 'http',
    debugLevel: 'ERROR' // 'ALL'|'DEBUG'|'INFO'|'ERROR'
}

const populationCount = 1000;

function logFunc(func){
    console.log(func.name);
}



function coreExists(core){
    logFunc(coreExists);
    let endpoint = solr + core + '/admin/ping'

    console.log(endpoint);

    return request(endpoint)    
    .then(function (response, body) {
        console.log('pinged!')
        return true;
    })
    .catch(function (err) {
        console.log('couldnt ping')
        return false;
    });
}



function init(){
    logFunc(init);

    solr = solrConfig.protocol + '://' +
               solrConfig.host + ':' +
               solrConfig.port + '/solr/'

    solrClient = solrAPI.getClient(solrConfig);


    coreExists('population')    
    .then(function (exists) {
        console.log('checkExists: ' + exists)

        if(exists === true){
            console.log('core exists');
        }
        else{
            // Generate core
        }

        console.log('ready to generate');
        for(var i = 0; i < populationCount; i++){
            let person = generatePerson();
            solrAPI.index(solrClient, person);
        }
    })
    .catch(function (err) {
        console.log('dgwefw')
        return false;
    });
}





function generatePerson(){
    logFunc(generatePerson);

    return {
        'city': faker.address.city(),
        'country': faker.address.country(),
        // 'zipcode': faker.address.zipCode(),
        'streetname': faker.address.streetName(),
        'county': faker.address.county(),
        'state': faker.address.state(), // abbreviation
        'latitude': faker.address.latitude(),
        'longitude': faker.address.longitude(),
        'companyname': faker.company.companyName(),
        'birthday': faker.date.past(50),
        'firstname': faker.name.firstName(), // gender
        'lastname': faker.name.lastName(), // gender
        'jobtitle': faker.name.jobTitle(),
        'jobdescription': faker.name.jobDescriptor(),
        'phonenumber': faker.phone.phoneNumber('###-###-####'),
        'email': faker.internet.email(this.firstname, this.lastname)
    }
}


init();








function generateCore(coreName, cb){
    logFunc(generateCore);

    //admin/cores?action=CREATE
    //&name=my_core
    //&collection=my_collection
    //&shard=shard2
    //&instanceDir=path/to/dir
    //&config=solrconfig.xml
    //&dataDir=data

    
    // TODO: https://github.com/docker-solr/docker-solr/issues/139
    let endpoint = solr + 'admin/cores?action=CREATE&name=' + coreName + '&instanceDir=/opt/solr/server/solr/configsets/_default'
    
    console.log(endpoint);

    request(endpoint)
    .then(function (response, body) {
        console.log('generated core!')
        cb(true);
    })
    .catch(function (err) {
        console.log('couldnt generate core')
        console.log(err)
        return false;
    });
}