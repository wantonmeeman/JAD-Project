const express=require('express');
const serveStatic=require('serve-static');

var hostname="localhost";
var port=3001;

var app=express();

app.use(function(req,res,next){
    console.log(req.url);
    console.log(req.method);
    console.log(req.path);
    console.log(req.query.id);

    next();
});


app.use(serveStatic(__dirname+"/public"));


app.listen(port,hostname,function(){

    console.log(`Server hosted at http://${hostname}:${port}`);
});



/* const app = express();

app.use(express.static("public"))

app.get("/login", (req, res) => {
  res.sendFile("/public/loginpage.html", { root: __dirname });
});

app.get("/home", (req, res) => {
    res.sendFile("/public/index.html", { root: __dirname });
});

app.get("/profile", (req, res) => {
    res.sendFile("/public/profile.html", { root: __dirname });
});

app.get("/addlisting", (req, res) => {
    res.sendFile("/public/addlisting.html", { root: __dirname });
});



const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Client server has started listening on port ${PORT}`);
}); */
