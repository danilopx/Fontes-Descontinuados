#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACD009    บ Autor ณ Paulo Bindo        บ Data ณ  07/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ CONTAGEM DE ITENS NA ROTINA MESTRE DE INVENTARIO           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ACD009()
Local nOpc := 0
Private oEstoque
Private lProd := .F.
Private lEnd:= .F.

Private nTotCont	:=0
Private nSemCont	:=0
Private nPorcSem	:=0
Private n1Cont 	:=0
Private nPorc1 	:=0
Private n2Cont 	:=0
Private nPorc2 	:=0
Private n3Cont 	:=0
Private nPorc3 	:=0
Private n4Cont 	:=0
Private nPorc4 	:=0
Private oTotCont,oSemCont,oPorcSem,o1Cont ,oPorc1 ,o2Cont ,oPorc2 ,o3Cont ,oPorc3 ,o4Cont ,oPorc4

SetKey(VK_F5, { || (ACD09PROC(),.T.) } )

If ! Pergunte("AIA031",.T.)  //Seleciona Produto ou Endereco
	Return
EndIf
If mv_par01 == 01 //Produto
	If ! Pergunte("AIA032",.T.)
		Return
	EndIf
	lProd := .T.
Else //Endereco
	If ! Pergunte("AIA030",.T.)
		Return
	EndIf
	lEnd:= .T.
EndIf



define msDialog oEstoque from 0,0 to 230,290 title "Status Inventario" Of oEstoque Pixel
@ 005,005 say "Total Cont." size  90,07 Of oEstoque Pixel
@ 005,037 MSget oTotCont VAR nTotCont When .F. size 21,08 Of oEstoque Pixel

@ 018,005 say "Sem Cont." size  90,07 Of oEstoque Pixel
@ 018,037 MSget oSemCont VAR nSemCont When .F. size 21,08 Of oEstoque Pixel
@ 018,069 MSget oPorcSem VAR nPorcSem When .F. size 21,08 Of oEstoque Pixel

@ 031,005 say "1 Contagem" size  90,07 Of oEstoque Pixel
@ 031,037 MSget o1Cont VAR n1Cont When .F. size 21,08 Of oEstoque Pixel
@ 031,069 MSget oPorc1 VAR nPorc1 When .F. size 21,08 Of oEstoque Pixel

@ 044,005 say "2 Contagem" size  90,07 Of oEstoque Pixel
@ 044,037 MSget o2Cont VAR n2Cont When .F. size 21,08 Of oEstoque Pixel
@ 044,069 MSget oPorc2 VAR nPorc2 When .F. size 21,08 Of oEstoque Pixel

@ 058,005 say "                    Etapa Final" size  90,07 Of oEstoque Pixel

@ 065,005 say "3 Contagem" size  90,07 Of oEstoque Pixel
@ 065,037 MSget o3Cont VAR n3Cont When .F. size 21,08 Of oEstoque Pixel
@ 065,069 MSget oPorc3 VAR nPorc3 When .F. size 21,08 Of oEstoque Pixel

@ 080,005 say "Finalizado" size  90,07 Of oEstoque Pixel
@ 080,037 MSget o4Cont VAR n4Cont When .F. size 21,08 Of oEstoque Pixel
@ 080,069 MSget oPorc4 VAR nPorc4 When .F. size 21,08 Of oEstoque Pixel

//EXECUTA AS QUERYS
ACD09PROC()

@ 100,010 BUTTON "Refresh<F5>"  SIZE 40,12 ACTION ACD09PROC() PIXEL OF oEstoque
define sButton from 100,060 type 1 action(oEstoque:End()) enable  Of oEstoque Pixel
@ 100,100 BUTTON "Nova Cons."  SIZE 40,12 ACTION (oEstoque:End(),nOpc := 1) PIXEL OF oEstoque

activate msDialog oEstoque center

If nOpc == 1
	U_ACD009()
EndIf
SetKey(VK_F5,Nil)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACD009    บAutor  ณMicrosiga           บ Data ณ  01/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ACD09PROC()
//TOTAL CONTAGEM
cQuery := " SELECT COUNT(*) CONTAR FROM "+RetSqlName("CBA")+" WHERE D_E_L_E_T_ <> '*' AND CBA_FILIAL = '"+xFilial("CBA")+"'"
If lProd
	cQuery += " AND CBA_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par05)+"'"
Else //ENDERECO
	cQuery += " AND CBA_LOCALI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND CBA_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'	"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par06)+"'"
EndIf
MemoWrite("ACD009.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
dbGoTop()

nTotCont := TRB->CONTAR

TRB->(dbCloseArea())


//SEM CONTAGEM
cQuery := " SELECT COUNT(*) CONTAR FROM "+RetSqlName("CBA")+" WHERE D_E_L_E_T_ <> '*' and CBA_CONTR = '0' AND CBA_FILIAL = '"+xFilial("CBA")+"'"
If lProd
	cQuery += " AND CBA_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par05)+"'"
Else //ENDERECO
	cQuery += " AND CBA_LOCALI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND CBA_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'	"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par06)+"'"
EndIf
MemoWrite("ACD009.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
dbGoTop()

nSemCont := TRB->CONTAR
nPorcSem :=  AllTrim(Str(Round((nSemCont/nTotCont)*100,2)))+"%"
TRB->(dbCloseArea())

//PRIMEIRA CONTAGEM
cQuery := " SELECT COUNT(*) CONTAR1 FROM "+RetSqlName("CBA")+" WHERE D_E_L_E_T_ <> '*' and CBA_CONTR = '1' AND CBA_FILIAL = '"+xFilial("CBA")+"'"
If lProd
	cQuery += " AND CBA_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par05)+"'"
Else //ENDERECO
	cQuery += " AND CBA_LOCALI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND CBA_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'	"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par06)+"'"
EndIf

MemoWrite("ACD0091.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
dbGoTop()

n1Cont := TRB->CONTAR1
nPorc1 := AllTrim(Str(Round((n1Cont/nTotCont)*100,2)))+"%"
TRB->(dbCloseArea())

//SEGUNDA CONTAGEM
cQuery := " SELECT COUNT(*) CONTAR2 FROM "+RetSqlName("CBA")+" WHERE D_E_L_E_T_ <> '*' and CBA_CONTR = '2' AND CBA_FILIAL = '"+xFilial("CBA")+"'"
If lProd
	cQuery += " AND CBA_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par05)+"'"
Else //ENDERECO
	cQuery += " AND CBA_LOCALI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND CBA_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'	"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par06)+"'"
EndIf

MemoWrite("ACD0092.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
dbGoTop()

n2Cont := TRB->CONTAR2
nPorc2 := AllTrim(Str(Round((n2Cont/nTotCont)*100,2)))+"%"
TRB->(dbCloseArea())

//TERCEIRA CONTAGEM
cQuery := " SELECT COUNT(*) CONTAR3 FROM "+RetSqlName("CBA")+" WHERE D_E_L_E_T_ <> '*' and CBA_CONTR = '2' and CBA_STATUS <> '4' AND CBA_FILIAL = '"+xFilial("CBA")+"'"
If lProd
	cQuery += " AND CBA_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par05)+"'"
Else //ENDERECO
	cQuery += " AND CBA_LOCALI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND CBA_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'	"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par06)+"'"
EndIf

MemoWrite("ACD0093.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
dbGoTop()

n3Cont := TRB->CONTAR3
nPorc3 := AllTrim(Str(Round((n3Cont/nTotCont)*100,2)))+"%"
TRB->(dbCloseArea())

//FINALIZADO
cQuery := " SELECT COUNT(*) CONTAR4 FROM "+RetSqlName("CBA")+" WHERE D_E_L_E_T_ <> '*' and CBA_STATUS = '4' AND CBA_FILIAL = '"+xFilial("CBA")+"'"
If lProd
	cQuery += " AND CBA_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par05)+"'"
Else //ENDERECO
	cQuery += " AND CBA_LOCALI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND CBA_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'	"
	cQuery += " AND CBA_DATA = '"+Dtos(mv_par06)+"'"
EndIf

MemoWrite("ACD0094.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
dbGoTop()

n4Cont := TRB->CONTAR4
nPorc4 := AllTrim(Str(Round((n4Cont/nTotCont)*100,2)))+"%"
TRB->(dbCloseArea())

oTotCont:Refresh()
oSemCont:Refresh()
oPorcSem:Refresh()
o1Cont:Refresh()
oPorc1:Refresh()
o2Cont:Refresh()
oPorc2:Refresh()
o3Cont:Refresh()
oPorc3:Refresh()
o4Cont:Refresh()
oPorc4:Refresh()
Return
