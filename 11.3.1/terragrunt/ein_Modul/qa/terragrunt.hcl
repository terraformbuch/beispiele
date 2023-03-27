terraform {
  source = "git::git@github.com:FirmaBeispiel/modul_anwendung_mit_datenbank_und_netzwerk.git//app?ref=v0.0.3"
}

inputs = {
  instance_count = 30
  instance_type  = "t2.medium"
}
