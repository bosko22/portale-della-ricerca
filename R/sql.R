#Query----

#### query ore lavorate per il calcolo dei fteq----
queryOre <- "SELECT
  dbo.IZS_Livello0.Livello0,
  dbo.IZS_Dipartimenti.DIPARTIMENTO,
  dbo.IZS_Reparti.REPARTO,
  dbo.IZS_CDC.CENTRO_DI_COSTO,
  dbo.Personale_V2020.CDC,
  dbo.Personale_V2020.Anno,
  dbo.Personale_V2020.Matricola,
  dbo.Personale_V2020.Ore,
  dbo.Personale_V2020.SmartWorking,
  dbo.Personale_V2020.Dirigente,
  dbo.Personale_V2020.Contratto,
  dbo.Personale_V2020.Percentuale,
  dbo.Personale_V2020.Mese,
  dbo.Personale_V2020.FineRapporto,
  dbo.Personale_V2020.Nome,
  dbo.Personale_V2020.Cognome
FROM
  dbo.Personale_V2020 INNER JOIN dbo.IZS_CDC ON (dbo.Personale_V2020.CDC=dbo.IZS_CDC.CODICE_CDC)
   INNER JOIN dbo.IZS_Reparti ON (dbo.IZS_CDC.CODICE_REPARTO=dbo.IZS_Reparti.CODICE_REPARTO)
   INNER JOIN dbo.IZS_Dipartimenti ON (dbo.IZS_Reparti.CODICE_DIPARTIMENTO=dbo.IZS_Dipartimenti.CODICE_DIPARTIMENTO)
   INNER JOIN dbo.IZS_Livello0 ON (dbo.IZS_Dipartimenti.Codice_Livello0=dbo.IZS_Livello0.CODICE_Livello0)
  
WHERE
  dbo.Personale_V2020.Anno  >=  2019"



#### query  Controllo di Gestione per Dashboard Performance e APP Centri di Costo----
queryCoge <- "SELECT IZS_ANNI.ANNO, IZS_TRIMESTRI.TRIMESTRE, IZS_MESI.MESE, IZS_MESI.Descrizione, 
                  IZS_Livello0.Livello0 AS Dipartimento, 
                  IZS_Dipartimenti.DIPARTIMENTO As Reparto, 
                  IZS_Reparti.REPARTO AS Laboratorio, 
                  SUM(CDC_MOVIMENTI_BO.Reale) AS Fatturato, 
                  SUM(CDC_MOVIMENTI_BO.Nominale) AS Tariffario, 
                  SUM(CDC_MOVIMENTI_BO.Costo) AS Costo, 
                  SUM(CDC_MOVIMENTI_BO.Determinazioni) AS Determinazioni, 
                  SUM(CDC_MOVIMENTI_BO.Quantita) AS Numero, 
                  IZS_Categorie.Descrizione AS Categoria, 
                  IZS_Riclassificazione.Descrizione AS Classificazione, 
                  IZS_Riclassificazione.idClassificazione, 
                  Elenco_Tipi_Movimenti.Descrizione AS Costi, 
                  IZS_Classi.Descrizione AS Classe, 
                  IZS_Aree.Descrizione AS Area, 
                  IZS_CDC.CODICE_CDC AS CodiceCDC, 
                  IZS_CDC.CENTRO_DI_COSTO AS CDC
FROM              IZS_Categorie INNER JOIN
                  IZS_Classi ON IZS_Categorie.TipoCostoRicavo = IZS_Classi.TipoCostoRicavo AND IZS_Categorie.Codice = IZS_Classi.Codice_categoria INNER JOIN
                  IZS_Aree ON IZS_Classi.TipoCostoRicavo = IZS_Aree.TipoCostoRicavo AND IZS_Classi.Codice = IZS_Aree.Codice_classe INNER JOIN
                  CDC_MOVIMENTI_BO ON IZS_Aree.TipoCostoRicavo = CDC_MOVIMENTI_BO.TipoCostoRicavo AND IZS_Aree.Codice_classe = CDC_MOVIMENTI_BO.Classe AND IZS_Aree.Codice_area = CDC_MOVIMENTI_BO.Area INNER JOIN
                  IZS_Classificazioni ON IZS_Classificazioni.idClassificazione = CDC_MOVIMENTI_BO.IdClassificazione INNER JOIN
                  IZS_Riclassificazione ON IZS_Riclassificazione.idClassificazione = IZS_Classificazioni.idRiclassifica INNER JOIN
                  Elenco_Tipi_Movimenti ON CDC_MOVIMENTI_BO.TipoCostoRicavo = Elenco_Tipi_Movimenti.TipoMovimento INNER JOIN
                  IZS_CDC ON IZS_CDC.CODICE_CDC = CDC_MOVIMENTI_BO.CDC INNER JOIN
                  IZS_Reparti ON IZS_Reparti.CODICE_REPARTO = IZS_CDC.CODICE_REPARTO INNER JOIN
                  IZS_Dipartimenti ON IZS_Dipartimenti.CODICE_DIPARTIMENTO = IZS_Reparti.CODICE_DIPARTIMENTO INNER JOIN
                  IZS_Livello0 ON IZS_Livello0.CODICE_Livello0 = IZS_Dipartimenti.Codice_Livello0 INNER JOIN
                  IZS_ANNI ON IZS_ANNI.ANNO = CDC_MOVIMENTI_BO.ANNO INNER JOIN
                  IZS_MESI ON IZS_MESI.MESE = CDC_MOVIMENTI_BO.MESE INNER JOIN
                  IZS_TRIMESTRI ON IZS_TRIMESTRI.TRIMESTRE = CDC_MOVIMENTI_BO.TRIMESTRE
                  
WHERE  (IZS_ANNI.ANNO >= 2019)
GROUP BY IZS_ANNI.ANNO, IZS_TRIMESTRI.TRIMESTRE, IZS_MESI.MESE, IZS_MESI.Descrizione, IZS_Livello0.Livello0, IZS_Dipartimenti.DIPARTIMENTO, IZS_Reparti.REPARTO, IZS_Categorie.Descrizione, IZS_Riclassificazione.Descrizione, 
                  IZS_Riclassificazione.idClassificazione, Elenco_Tipi_Movimenti.Descrizione, IZS_Classi.Descrizione, IZS_Aree.Descrizione, IZS_CDC.CODICE_CDC, IZS_CDC.CENTRO_DI_COSTO"


#### query dati per accettazione centralizzata----
queryAcc <- ("SELECT
  {fn year(dbo.Conferimenti.Data_Accettazione)} AS Anno,
  dbo.Conferimenti.Nome_Stazione_Inserimento AS PC,
  dbo.Conferimenti.Numero AS Nconf,
  dbo_Anag_Reparti_ConfProp.Descrizione AS StrPropr,
  dbo_Anag_Reparti_ConfAcc.Descrizione AS StrAcc,
  dbo_Operatori_di_sistema_ConfMatr.Descr_Completa AS Operatore,
  dbo_Anag_Reparti_ConfProp.Locazione AS LocStrutt,
  dbo_Anag_Finalita_Confer.Descrizione AS Finalita,
  dbo.Anag_Registri.Descrizione AS Settore,
  dbo.Anag_TipoConf.Descrizione AS Pagamento,
  dbo.Conferimenti.Data_Inserimento AS dtreg,
  dbo.Anag_Specie.Descrizione AS Specie ,
  dbo.Anag_Materiali.Descrizione AS Materiale,
  dbo.Anag_Matrici.Descrizione AS Matrice,
  dbo.Anag_Supergruppo_Specie.Descrizione AS SupergruppoSpecie,
  dbo.Anag_Gruppo_Specie.Descrizione AS GruppoSpecie,
  dbo.Anag_Prove.Descrizione AS Prova,
  dbo.Anag_Tipo_Prel.Descrizione AS Tipoprel,
  dbo.RDP_Date_Emissione.Istanza_RDP AS Istanzardp,
  convert (SMALLDATETIME, dbo.Conferimenti.Data_Primo_RDP_Completo_Firmato) AS dtprimotrdp,
  dbo.RDP_Date_Emissione.Data_RDP AS dturp,
  Datename(weekday, dbo.Conferimenti.Data_Accettazione) AS Giornoacc,
  dbo.Conferimenti.NrCampioni
FROM
{ oj dbo.Anag_Reparti  dbo_Anag_Reparti_ConfProp INNER JOIN dbo.Laboratori_Reparto  dbo_Laboratori_Reparto_ConfProp ON ( dbo_Laboratori_Reparto_ConfProp.Reparto=dbo_Anag_Reparti_ConfProp.Codice )
   INNER JOIN dbo.Conferimenti ON ( dbo.Conferimenti.RepLab=dbo_Laboratori_Reparto_ConfProp.Chiave )
   LEFT OUTER JOIN dbo.Anag_Matrici ON ( dbo.Conferimenti.Matrice=dbo.Anag_Matrici.Codice )
   LEFT OUTER JOIN dbo.Esami_Aggregati ON ( dbo.Conferimenti.Anno=dbo.Esami_Aggregati.Anno_Conferimento and dbo.Conferimenti.Numero=dbo.Esami_Aggregati.Numero_Conferimento )
   LEFT OUTER JOIN dbo.Nomenclatore_MP ON ( dbo.Esami_Aggregati.Nomenclatore=dbo.Nomenclatore_MP.Codice )
   LEFT OUTER JOIN dbo.Nomenclatore_Settori ON ( dbo.Nomenclatore_MP.Nomenclatore_Settore=dbo.Nomenclatore_Settori.Codice )
   LEFT OUTER JOIN dbo.Nomenclatore ON ( dbo.Nomenclatore_Settori.Codice_Nomenclatore=dbo.Nomenclatore.Chiave )
   LEFT OUTER JOIN dbo.Anag_Prove ON ( dbo.Nomenclatore.Codice_Prova=dbo.Anag_Prove.Codice )
   INNER JOIN dbo.Anag_Tipo_Prel ON ( dbo.Conferimenti.Tipo_Prelievo=dbo.Anag_Tipo_Prel.Codice )
   INNER JOIN dbo.Anag_Registri ON ( dbo.Conferimenti.Registro=dbo.Anag_Registri.Codice )
   INNER JOIN dbo.Laboratori_Reparto  dbo_Laboratori_Reparto_ConfAcc ON ( dbo.Conferimenti.RepLab_Conferente=dbo_Laboratori_Reparto_ConfAcc.Chiave )
   INNER JOIN dbo.Anag_Reparti  dbo_Anag_Reparti_ConfAcc ON ( dbo_Laboratori_Reparto_ConfAcc.Reparto=dbo_Anag_Reparti_ConfAcc.Codice )
   INNER JOIN dbo.Anag_TipoConf ON ( dbo.Anag_TipoConf.Codice=dbo.Conferimenti.Tipo )
   LEFT OUTER JOIN dbo.Anag_Materiali ON ( dbo.Anag_Materiali.Codice=dbo.Conferimenti.Codice_Materiale )
   LEFT OUTER JOIN dbo.Anag_Specie ON ( dbo.Anag_Specie.Codice=dbo.Conferimenti.Codice_Specie )
   LEFT OUTER JOIN dbo.Anag_Gruppo_Specie ON ( dbo.Anag_Specie.Cod_Darc1=dbo.Anag_Gruppo_Specie.Codice )
   LEFT OUTER JOIN dbo.Anag_Supergruppo_Specie ON ( dbo.Anag_Gruppo_Specie.Cod_Supergruppo=dbo.Anag_Supergruppo_Specie.Codice )
   INNER JOIN dbo.Conferimenti_Finalita ON ( dbo.Conferimenti.Anno=dbo.Conferimenti_Finalita.Anno and dbo.Conferimenti.Numero=dbo.Conferimenti_Finalita.Numero )
   INNER JOIN dbo.Anag_Finalita  dbo_Anag_Finalita_Confer ON ( dbo.Conferimenti_Finalita.Finalita=dbo_Anag_Finalita_Confer.Codice )
   INNER JOIN dbo.Operatori_di_sistema  dbo_Operatori_di_sistema_ConfMatr ON ( dbo.Conferimenti.Matr_Ins=dbo_Operatori_di_sistema_ConfMatr.Ident_Operatore )
   LEFT OUTER JOIN dbo.RDP_Date_Emissione ON ( dbo.RDP_Date_Emissione.Anno=dbo.Conferimenti.Anno and dbo.RDP_Date_Emissione.Numero=dbo.Conferimenti.Numero )
  }
WHERE
  dbo.Esami_Aggregati.Esame_Altro_Ente = 0
  AND  dbo.Esami_Aggregati.Esame_Altro_Ente = 0
  AND  (
  {fn year(dbo.Conferimenti.Data_Accettazione)}  =  2021
  AND  dbo.Conferimenti.Nome_Stazione_Inserimento  IN  ('ACC-CENTR2', 'PC-47326', 'PC-40780','MP-ACC3', 'BS-ASS-N',
                                                        'PC-47327', 'CH-ACC4-N','CH-ACC2-N', 'MP-SIVARS7','PC-47499', 
                                                        'MP-SIVARS7-N', 'PC-49702')
  )
")

#### query dati performance

queryPERF <- "SELECT
Avanzamento,
Valore,
Target, 
Anno,
TipoObiettivo,
Periodo,
MacroArea,Obiettivo,
Azione,
Indicatore,
StrutturaAssegnataria

FROM ObiettiviStrategiciV2018.dbo.v_EstrazioneObiettivi
WHERE Anno > 2020"

