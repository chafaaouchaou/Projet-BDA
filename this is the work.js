use ('ProjetBDA')

db.Prets.insertMany([
    {
      "NumPrêt": 1,
      "montantPrêt": 10000.00,
      "dateEffet": ISODate("2024-04-29"),
      "durée": 24,
      "typePrêt": "Véhicule",
      "tauxIntérêt": 0.05,
      "montantEchéance": 500.00,
      "Compte": {
        "NumCompte": 1,
        "dateOuverture": ISODate("2024-01-15"),
        "étatCompte": "Actif",
        "Solde": 5000.00,
        "Client": {
          "NumClient": 1,
          "NomClient": "Nom du client",
          "TypeClient": "Particulier",
          "AdresseClient": "Adresse du client",
          "NumTel": "Numéro de téléphone",
          "Email": "Adresse email"
        },
        "Agence": {
          "NumAgence": 102,
          "nomAgence": "Nom de l'agence",
          "adresseAgence": "Adresse de l'agence",
          "catégorie": "Principale",
          "Succursale": {
            "NumSucc": 1,
            "nomSucc": "Nom de la succursale",
            "adresseSucc": "Adresse de la succursale",
            "région": "Nord"
          }
        }
      }
    }
])

db.Opérations.insertMany([
    {
      "NumOpération": 1,
      "NatureOp": "Crédit",
      "montantOp": 500.25,
      "DateOp": ISODate("2024-04-29"),
      "Observation": "Observation sur l'opération",
      "Compte": {
        "NumCompte": 1,
        "dateOuverture": ISODate("2024-01-15"),
        "étatCompte": "Actif",
        "Solde": 5000.00,
        "Client": {
          "NumClient": 1,
          "NomClient": "Nom du client",
          "TypeClient": "Particulier",
          "AdresseClient": "Adresse du client",
          "NumTel": "Numéro de téléphone",
          "Email": "Adresse email"
        },
        "Agence": {
          "NumAgence": 102,
          "nomAgence": "Nom de l'agence",
          "adresseAgence": "Adresse de l'agence",
          "catégorie": "Principale",
          "Succursale": {
            "NumSucc": 1,
            "nomSucc": "Nom de la succursale",
            "adresseSucc": "Adresse de la succursale",
            "région": "Nord"
          }
        }
      }
    }
])



// Fonction pour générer des données aléatoires pour les prêts
use ('ProjetBDA')
function genererPret() {
    return {
        "NumPrêt": Math.floor(Math.random() * 200) + 1,
        "montantPrêt": parseFloat((Math.random() * (100000 - 1000) + 1000).toFixed(2)),
        "dateEffet": new Date(),
        "durée": Math.floor(Math.random() * (60 - 12) + 12),
        "typePrêt": "Véhicule",
        "tauxIntérêt": parseFloat((Math.random() * 0.1).toFixed(2)),
        "montantEchéance": parseFloat((Math.random() * (5000 - 50) + 50).toFixed(2)),
        "Compte": {
            "NumCompte": Math.floor(Math.random() * 200) + 1,
            "dateOuverture": new Date(),
            "étatCompte": "Actif",
            "Solde": parseFloat((Math.random() * (100000 - 1000) + 1000).toFixed(2)),
            "Client": {
                "NumClient": Math.floor(Math.random() * 200) + 1,
                "NomClient": "Client " + Math.floor(Math.random() * 10) + 1,
                "TypeClient": "Particulier",
                "AdresseClient": "Adresse " + Math.floor(Math.random() * 100) + 1,
                "NumTel": "Numéro " + Math.floor(Math.random() * 1000000) + 1,
                "Email": "Email" + Math.floor(Math.random() * 100) + 1 + "@example.com"
            },
            "Agence": {
                "NumAgence": Math.floor(Math.random() * 100) + 101,
                "nomAgence": "Agence " + Math.floor(Math.random() * 10) + 1,
                "adresseAgence": "Adresse " + Math.floor(Math.random() * 100) + 1,
                "catégorie": "Principale",
                "Succursale": {
                    "NumSucc": Math.floor(Math.random() * 10) + 1,
                    "nomSucc": "Succursale " + Math.floor(Math.random() * 5) + 1,
                    "adresseSucc": "Adresse " + Math.floor(Math.random() * 20) + 1,
                    "région": "Nord"
                }
            }
        }
    };
}


// for (let i = 0; i < 2; i++) {
//     let pret = genererPret();
//     db.Prets.insertOne(pret);
// }


// use ('ProjetBDA')
// db.Prets.deleteMany({});
// db.Opérations.deleteMany({});

// Fonction pour générer des données aléatoires pour les opérations
function genererOperation() {
    return {
        "NumOpération": Math.floor(Math.random() * 200) + 1,
        "NatureOp": "Crédit",
        "montantOp": parseFloat((Math.random() * (1000 - 10) + 10).toFixed(2)),
        "DateOp": new Date(),
        "Observation": "Observation sur l'opération",
        "Compte": {
            "NumCompte": Math.floor(Math.random() * 200) + 1,
            "dateOuverture": new Date(),
            "étatCompte": "Actif",
            "Solde": parseFloat((Math.random() * (100000 - 1000) + 1000).toFixed(2)),
            "Client": {
                "NumClient": Math.floor(Math.random() * 200) + 1,
                "NomClient": "Client " + Math.floor(Math.random() * 10) + 1,
                "TypeClient": "Particulier",
                "AdresseClient": "Adresse " + Math.floor(Math.random() * 100) + 1,
                "NumTel": "Numéro " + Math.floor(Math.random() * 1000000) + 1,
                "Email": "Email" + Math.floor(Math.random() * 100) + 1 + "@example.com"
            },
            "Agence": {
                "NumAgence": Math.floor(Math.random() * 100) + 101,
                "nomAgence": "Agence " + Math.floor(Math.random() * 10) + 1,
                "adresseAgence": "Adresse " + Math.floor(Math.random() * 100) + 1,
                "catégorie": "Principale",
                "Succursale": {
                    "NumSucc": Math.floor(Math.random() * 10) + 1,
                    "nomSucc": "Succursale " + Math.floor(Math.random() * 5) + 1,
                    "adresseSucc": "Adresse " + Math.floor(Math.random() * 20) + 1,
                    "région": "Nord"
                }
            }
        }
    };
}

// Insertion des prêts dans la collection "Prêts"
for (let i = 0; i < 200; i++) {
    let pret = genererPret();
    db.Prets.insertOne(pret);
}

// Insertion des opérations dans la collection "Opérations"
for (let i = 0; i < 200; i++) {
    let operation = genererOperation();
    db.Opérations.insertOne(operation);
}



// 1111111

use ('ProjetBDA')
db.Prets.find({"Compte.Agence.NumAgence": 102})

// 222222222
use ('ProjetBDA')
db.Prets.aggregate([
    {
      $match: {
        "Compte.Agence.Succursale.région": "Nord"
      }
    },
    {
      $project: {
        "NumPrêt": 1,
        "Compte.Agence.NumAgence": 1,
        "Compte.NumCompte": 1,
        "Compte.Client.NumClient": 1,
        "montantPrêt": 1,
        "Compte.Agence.Succursale.région": 1
      }
    }
])


// 3333333
use ('ProjetBDA')
db.Prets.aggregate([
    {
      $group: {
        _id: "$Compte.Agence.NumAgence",
        totalPrets: { $sum: 1 }
      }
    },
    {
      $sort: {
        totalPrets: -1
      }
    },
    {
      $out: "Agence-NbPrets"
    }
])

// To display the content of the new collection
db['Agence-NbPrets'].find()


// 4444444

use ('ProjetBDA')
db.Prets.aggregate([
    {
        $match: {
        "typePrêt": "ANSEJ"
      }
    },
    {
      $project: {
        "NumPrêt": 1,
        "Compte.Client.NumClient": 1,
        "montantPrêt": 1,
        "dateEffet": 1
      }
    },
    {
      $out: "Prêt-ANSEJ"
    }
])
          

// 555555
use ('ProjetBDA')

db.Prets.find(
    { "Compte.Client.TypeClient": "Particulier" },
    { "Compte.Client.NumClient": 1, "Compte.NomClient": 1, "NumPrêt": 1, "montantPrêt": 1 }
).toArray();

// 666666666

use ('ProjetBDA')
db.Prets.updateMany(
    {
        "dateEffet": { $lt: new Date("2025-01-01") },
        "étatPrêt": { $ne: "Soldé" }
    },
    {
        $inc: { "montantEchéance": 2000 }
    }
)

// 77777777777777


use ('ProjetBDA')
db.Prets.mapReduce(
    function() {
        emit(this.Compte.Agence.NumAgence, 1);
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        out: { replace: "Agence-NbPrêts2" },
        sort: { value: -1 }
    }
)


use ('ProjetBDA')
db.Opérations.find({
    "NatureOp": "Crédit",
    "Compte.Client.TypeClient": "Entreprise",
    "DateOp": {
        $gte: ISODate("2023-01-01"),
        $lt: ISODate("2026-01-01")
    }
})




















