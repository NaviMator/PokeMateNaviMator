const {app, BrowserWindow} = require('electron')
const url = require('url')
const fs = require('fs')
const path = require('path')

let win  

function createWindow() { 
   win = new BrowserWindow({
      webPreferences: {
         nodeIntegration: true,
         contextIsolation: false
      },
      width: 1400,
      height: 860
   });
   //win.webContents.openDevTools()
   win.loadURL(url.format ({ 
      pathname: path.join(__dirname, 'index.html'), 
      protocol: 'file:', 
      slashes: true
   })) 
}  

app.on('ready', createWindow)



