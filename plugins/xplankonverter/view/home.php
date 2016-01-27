    <!--  Javascript für Show und Hide () -->
    <script type="text/javascript" language="JavaScript">
    function HideContent(d) {
    document.getElementById(d).style.display = "none";
    }
    function ShowContent(d) {
    document.getElementById(d).style.display = "block";
    }
    function ReverseDisplay(d) {
    if(document.getElementById(d).style.display == "none") { document.getElementById(d).style.display = "block"; }
    else { document.getElementById(d).style.display = "none"; }
    }
    </script>
		<div class="textsite">
			<center>
      <h1>Modellvorhaben der Raumordnung</h1>
			<h2>Entwicklung und Implementierung eines Standards für den Datenaustausch in der Raumordnungsplanung</h2>
      <hr>
    </center>
        <h3>Änderungen zum 15.01.2016</h3>
        <ul>
        <li>Bereitstellung der <a href="http://xplan-raumordnung.de/iqvoc/de.html">Ontologie</a></li>
        <li>Bereitstellung einer <a href="http://xplan-raumordnung.de/index.php?go=show_inspire">INSPIRE-Sektion</a> mit Mapping-Tables von XPlan nach INSPIRE</li>
        <li>Die HSRCL-Zuordnung aller Planzeichen des ROPLAMO kann auf Wunsch ausgewählt werden</li>
        <li>Bereitstellung einer Liste aller Modelländerungen zum <a href="/model/2015_12_03_Aenderungsliste_XPlan_Raumordnungsmodell.doc">herunterladen</a></li>
        <li>Bereitstellung der Raumordnungsplan Konformitätsbedingungen <a href="/model/2016_01_11_Konformitaetsbedingungen.doc">herunterladen</a></li>
        <li>Zusammenfassung XPlan und ROPLAMO für XPlan Elemente und Codelisten sowie Pläne und Planzeichen im Menü mit Unterpunkten</li>
      </ul>
      <a href="javascript:ReverseDisplay('aeltereupdates')" class=hlink>
      Ältere Änderungen
      </a>
      <div id="aeltereupdates" style="display:none;">
          <h3>Änderungen zum 11.12.2015</h3>
          <ul>
          <li>Erweiterung des UML- und Datenbank-Modells, inklusive Änderungen auf Basis der Gespräche mit der AG E-Government und der Länder</li>      
          <li>Bereitstellung des INSPIRE HSRCL Übersetzungsvorschlags zum <a href="inspire/hsrcl_uebersetzung.xlsx">herunterladen</a></li>
          <li>Änderungen einiger Textstellen der Homepage</li>
        </ul>
          <h3>Änderungen zum 23.07.2015</h3>
          <ul>
          <li>Funktionen zum Export der Tabellen der Pläne und Planzeichen in die Formate (JSON, XML, CSV, TXT, SQL und MS-Excel)</li>      
          <li>Änderungen des UML- und Datenbank-Modells auf Basis der Gespräche mit der AG E-Government der MKRO (in UML sind besprochene Änderungen als graue Kommentare gekennzeichnet)</li>
          <li>Herausnahme von nicht-verbindlichen Plänen und Planzeichen aus den ROPLAMO-Tabellen</li>
          <li>Änderungen in den ROPLAMO-Zuordnungen auf Basis der erhaltenen Kommentare</li>
          <li>Erweiterte Dokumentation, zum Beispiel FeatureType-Definitionen in der UML-Modelldarstellung als Mouseover-Effekt</li>
          <li>Ein Modelldownload als PDF ist nun auf der Modell-Sektion möglich</li>
          <li>Weitere kleinere Änderungen und Bugfixes</li>
        </ul>
        
          <h3>Änderungen zum 16.09.2015</h3>
          
          <ul><li>Erweiterung des UML- und Datenbank-Modells, inklusive Änderungen auf Basis der Gespräche mit der AG E-Government</li>      
          <li>Bereitstellung des INSPIRE HSRCL Übersetzungsvorschlags zum <a href="inspire/hsrcl_uebersetzung.xlsx">herunterladen</a></li>
          <li>Änderungen in den ROPLAMO-Zuordnungen auf Basis der erhaltenen Kommentare</li>
        </ul>
      </div>
			<form action ="index.php">
			<input type="hidden"name="go" value="show_home">
      <h3>Einleitung</h3>
			<p>
				Um einen effektiven Austausch von Geodaten der Raumordnung im Bundesgebiet zu ermöglichen, der nicht nur die öffentliche Verwaltung, sondern auch Träger öffentlicher Belange, die Privatwirtschaft und Bürger mit einschließt, ist eine Standardisierung erforderlich, die auch den Umfang der bei den Geodaten zu dokumentierenden Sachattribute thematisiert. In dem Modellvorhaben der Raumordnung "Entwicklung und Implementierung eines Standards für den Datenaustausch in der Raumordnungsplanung" des Bundesinstituts für Bau-, Stadt- und Raumforschung (BBSR) wird das XPlanung-Datenaustauschformat für Raumordnungspläne in enger Zusammenarbeit mit der AG E-Government des Ausschusses für Struktur und Umwelt sowie der Länder weiterentwickelt.
			</p>
			<h3>XPlan</h3>
			<p>
				Die derzeitige Arbeitsversion des XPlan Raumordnungsmodells kann in der Sektion <a href=index.php?go=show_uml class=hlink>XPlan-Modell</a> des Menüpunktes XPlan als interaktives Unified Modelling Language Klassendiagramm eingesehen werden. Seine Grundlage bildet das Regionalplan Kernmodell von XPlan 4.1, welches auf Basis der Daten des Raumordnungsplanmonitors (ROPLAMO) des BBSR, der Erweiterungsmodelle Niedersachsen-Schleswig-Holstein-Mecklenburg-Vorpommern (NSM), Rheinland-Pfalz (RLP) sowie Nordrhein-Westfalen (NRW), Gespräche mit der AG E-Government, Gespräche mit den einzelnen Bundesländer und weiterer Quellen verbessert wurde. Gleichzeitig finden sich hier auch Downloads des Modells als Enterprise Architect-Datei, als XMI-Datei, die zum Modell gehörigen XSD's, eine Liste der Modelländerungen, eine PDF-Datei der relevanten UML-Graphiken und die erweiterten Konformitätsbedingungen des Modells.
			<p>
				In den Sektionen <a href=index.php?go=show_elements class=hlink>Xplan Elemente</a> und <a href=index.php?go=show_simple_types class=hlink>Codelisten</a> des Menüpunktes XPlan werden einzelnde Featuretypen, Enumerations und ähnliche Elemente des Modells aufgelistet, definiert und miteinander in Verknüpfung gestellt. Gleichzeitig bestehen Links zu Einträgen im xplanungwiki, falls diese dort vorhanden sind.<br>
			</p>
			<h3>ROPLAMO</h3>
			<p>
				Die im Raumordnungsplan-Monitor (ROPLAMO) aufgenommenen Daten wurden für das Projekt untersucht und ihre generelle Kompabilität in Bezug auf das erweiterte XPlan-Schema überprüft. Diese können von den Ländern eingesehen werden und dienen als Referenz für eine zukünftige Konvertierung der Daten. Die ROPLAMO-Daten sind in den Sektionen <a href=index.php?go=show_plaene class=hlink>Pläne</a> und <a href=index.php?go=show_planzeichen class=hlink>Planzeichen</a> des Menüpunktes ROPLAMO zu finden. Sie können z.B. länder-oder planspezifisch sortiert werden und erlauben gleichfalls einen optionalen Vergleich mit den Daten anderen Länder. Eine genauere Erläuterung der beiden Sektionen finden Sie im Menüpunkt Hilfe.
			</p>
			<p>
				Gleichzeitig können die vorgenommenen Kategorisierungsvorschläge der Planzeichen in das XPlan-Schema überprüft werden und gegebenenfalls falsche Kategorisierungen, Kommentare oder Erweiterungswünsche durch das dazugehörige Kommentarfeld durch einen Klick auf die Planzeichen-ID abgegeben werden. Hierbei ist zu überprüfen, ob die Daten dem Inhalt und der Funktion der Pläne und Planzeichen gerecht eingeordnet sind. Durch abgegebene Kommentare kann das Schema verbessert werden, um alle bestehenden Pläne und Planzeichen sinngerecht aufzunehmen.
			</p>
			<p>
				Raumordnungspläne selbst werden in XPlan dem FeatureType RP_Plan in RP_Basisobjekte zugeordnet. Dieser FeatureType hat den Anspruch, alle Raumordnungspläne, die auch im ROPLAMO enthalten sind, zu erfassen. Falls ein Plan hier nicht aufgenommen werden kann oder Erweiterungsbedarf des Pakets besteht, kann dieser nach Rücksprache erweitert werden.
			</p>
      <h3>INSPIRE</h3>
			<p>
				Die Sektion <a href=index.php?go=show_inspire class=hlink>INSPIRE</a> enthält Tabellen zum Mapping von XPlan nach INSPIRE, einen Übersetzungsvorschlag für die HSRCL-Codeliste sowie Dokumente zu Pflichtelementen und Attributierungen des Schemas.
			</p>
      <h3>Ontologie</h3>
			<p>
				In der <a href=http://xplan-raumordnung.de/iqvoc/de.html class=hlink>Ontologie</a> werden verschiedene Konzepte und Definitionen festgehalten. Es finden sich Konzepte zum XPlan-Modell, zum INSPIRE-Modell, den dazugehörigen HILUCS und HSRCL-Listen sowie die durch das Projekt entworfene Nationale Codeliste Deutschlands für Raumordnungsdaten und weitere Listen zu Planzeichenkatalogen verschiedener Länder. Die Elemente der verschiedenen Listen referenzieren sich und auch externe Thesauri gegenseitig, so dass zum Beispiel Definitionsunterschiede verschiedener Planzeichen nachgeschlagen werden können.
			</p>
      <h3>Kommentare</h3>
			<p>
				Die <a href=index.php?go=show_comments class=hlink>Kommentare</a>-Sektion beinhaltet abegebene Kommentare zu den ROPLAMO-Zuordnungen und Elementen sowie allgemeines Feedback der Planträger der Länder.
			</p>
			<h3>Hilfe</h3>
			<p>
				Die <a href=index.php?go=show_hilfe class=hlink>Hilfe</a>-Sektion beantwortet häufig gestellte Fragen und enthält weiterführende Links zum MORO Projekt und XPlanung.
			</p>
		</div>