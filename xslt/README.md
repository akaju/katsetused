
Mõned kahe dokumendiga katsetused.

data.xml   - sündmused loendatuna kohtade kaupa
places.xml - kohad loendatuna kontaktide kaupa

extract-events-with-places-and-contacts.xsl

võtab välja sündmused ja lisab juurde kontakti ning koha

Linuxis

xalan -xsl extract-events-with-places-and-contacts.xsl -in data.xml -out events-with-places-and-contacts.xml


Demonstreerib andmefaili (data.xml) teisendamist/rikastamist kasutades kataloogifaili (places.xml) andmeid.

