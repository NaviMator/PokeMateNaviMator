const path = require('path')
const fs = require('fs')
const dataBaseSettings = 'database/settingsDB.lua';

dontReadNow = false;

function readDatabase(){
  if(dontReadNow === false){
    try {
      dataBase = fs.readFileSync(path.resolve(dataBaseSettings), 'utf8');
      dataBase = dataBase.replaceAll("{","[");
      dataBase = dataBase.replaceAll("}","]");
      lines = dataBase.split(/[\r\n]+/);
      newDataBase = "";
      lines.forEach(function(line, idx, array){
        variablePart = line.split(" = ");
        eval(line);
      })
    } catch (err) {
      console.error("Error: Failed to load Database ("+err+")")
    }
  }
}


function writeDatabase(){
  dontReadNow = true;
  //console.log("database locked")
  try {
    dataBase = fs.readFileSync(path.resolve(dataBaseSettings), 'utf8');
    //dataBase = fs.readFileSync(dataBaseSettings, 'utf8')
    
    dataBase = dataBase.replaceAll("{","[");
    dataBase = dataBase.replaceAll("}","]");
    lines = dataBase.split(/[\r\n]+/);
    newDataBase = "";
    lines.forEach(function(line, idx, array){
      variablePart = line.split(" = ");
      variableInfos = line.split("_");
      if (variableInfos[0] == "pokemonArray"){
        variableValue = "{"+eval(variablePart[0])+"}";
      }else if(variableInfos[0] == "array") {
        variableValue = eval(variablePart[0]);
        variableValueInStrings = []
        variableValue.forEach(element => variableValueInStrings.push( "\"" + element + "\""));
        variableValueInStrings = variableValueInStrings.toString();
        variableValue = "{" + variableValueInStrings + "}";
      }else if(variableInfos[0] == "int") {
        variableValue = Math.round(eval(variablePart[0]));
      }else if(variableInfos[0] == "bool") {
        variableValue = eval(variablePart[0]);
      }else{
        variableValue = eval(variablePart[0]);
      }
      if (idx === array.length - 1){
        newDataBase = newDataBase.concat(variablePart[0], " = ", variableValue);
      }else{
        newDataBase = newDataBase.concat(variablePart[0], " = ", variableValue,"\n");
      }
    })
    
    //console.log(newDataBase);

    fs.writeFile(dataBaseSettings, newDataBase, function (err,data) {
      if (err) {
        console.error("Error: Failed to write Database ("+err+")")
      }else{
        //console.log("Database updated.")
      }
    });
    readDatabase()
  } catch (err) {
     console.error("Error: Failed to load Database ("+err+")")
  }

  setTimeout(() => {
    dontReadNow = false;
    //console.log("database unlocked")
  }, 500);

  
}
