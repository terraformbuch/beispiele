variable "ip_address" {
  description = "Cluster-IPs für die Datenbank"
  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.ip_address))
    error_message = "Ungültiges IP-Adress-Format. Beispielformat: 192.168.0.1/24."
  }
}

variable "betriebssystem" {
  validation {
    condition     = can(regex("^(SLES 15|RHEL 7|Ubuntu 20.04)$", var.betriebssystem))
    error_message = "Ungültiges Betriebssystem. Bitte aus 'SELS 15', 'RHEL 7' und 'Ubuntu 20.04' wählen."
  }
}
