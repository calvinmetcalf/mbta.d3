trainLine = document.getElementById("line").value
margin = 
	top: 20
	right: 20
	bottom: 30
	left: 50
width = 960 - margin.left - margin.right
height = 500 - margin.top - margin.bottom

trains = 
	ashmont:["RED","A"]
	braintree:["RED","Q"]
	blue:["BLUE"]
	orange:["ORANGE"]
	b:["GREEN","B"]
	c:["GREEN","C"]
	d:["GREEN","D"]
	e:["GREEN","E"]

x = d3.scale.linear().range([0, width])

y = d3.scale.linear().range([height,0])

xAxis = d3.svg.axis().scale(x).orient("bottom")

yAxis = d3.svg.axis().scale(y).orient("left")

setMap=()->
	d3.selectAll(".mbta path").style "visibility",(d)->
		if trains[trainLine].every((v)=> @classList.contains(v))
			"visible"
		else
			"hidden"

makeGraph=()->
	setMap()
	svg = d3.select("#graph").append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom)
		.append("g")
		.attr("transform", "translate( #{margin.left} , #{margin.top} )")
	line = d3.svg.line().x((d)->
		x d[trainLine]
	).y (d)->
		y d.income
	stations = data.filter((v)->
		v[trainLine]
	).map((v)->
		v[trainLine]=parseInt(v[trainLine],10)
		v.income=parseFloat(v.income,10)
		v
	).sort((a,b)->b[trainLine]-a[trainLine])
	if trainLine in ['ashmont','braintree','orange']
		x.domain([1,d3.max(stations, (d)->
			parseInt d[trainLine], 10
		)])
	else
		x.domain([d3.max(stations, (d)->
			parseInt d[trainLine], 10
		),1])
	y.domain([0,d3.max(stations, (d)->
		parseInt d.income, 10
	)])
	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0,#{height})")
		.call(xAxis).append("text").attr("y", 6).attr("x", 6)
		.attr("dx", ".71em")
		.attr("dy", "1.71em").style("text-anchor", "end")
		.text("stop number")
	svg.append("g")
		.attr("class", "y axis")
		.call(yAxis)
		.append("text")
		.attr("transform", "rotate(-90)")
		.attr("y", 6)
		.attr("dy", ".71em")
		.style("text-anchor", "end")
		.text("income $")
	svg.append("path")
		.datum(stations)
		.attr("class", "line")
		.attr("d", line)

d3.select('#line').on "change", ()->
	trainLine = document.getElementById("line").value
	d3.select("#graph svg").remove()
	makeGraph()

d3.csv "nodes.csv", (data) ->
	window.data = data
	makeGraph()

map = d3.select("#map").append("svg").attr("width", 200).attr("height", 200)
mapPath = d3.geo.path().projection(null)
d3.json 't.json', (topo)->
	window.topo = topo
	map.append("g").attr("transform","scale(1)translate(1,1)").attr("class", "mbta")
	.selectAll("path")
	.data(topojson.feature(topo, topo.objects.t).features)
	.enter().append("path")
	.attr("class", (d) ->
		"#{d.properties.LINE} #{if d.properties.ROUTE then d.properties.ROUTE else ''}"
	).attr("d", mapPath)
	setMap()
	true
