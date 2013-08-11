	COPYLEFT="\n<MagicNumber Scanner v1.0> by chr1x (http://chr1x.izpwning.me)\n\n";
	USAGE="\tUSE: #{$0} <input file> <optional output report.html>\n\n";
	INIT_TEXT="\t[*] Starting Magic-number scan on... ";
	TEMPLATE=<<-CONTENT
		<HTML>
			<HEAD>
				<TITLE></TITLE>
				<STYLE>
					body{
						background-color: grey
					}
					div.header{
						background-color: #cb4437;
						color: white;
						height: 100px;
					}
					div.content {
						width: 100%;
						background-color: #aaa;
						margin-top: 5px;
						margin-bottom: 10px;
						color: white;
						min-height: 500px;
					}			
					div.references{
						padding-left:50px;
						width: 92%;
						background-color: grey;
						margin: 5px;
					}		
				</STYLE>
			<HEAD>
			<BODY>
				<div class='header'>
					<br/><center><h2><<TITLE>></h2></center>
				</div>
				<div class='content'>
					<ul>
						<<REPORT>>
					</ul>
				</div>
			</BODY>
		</HTML>
CONTENT