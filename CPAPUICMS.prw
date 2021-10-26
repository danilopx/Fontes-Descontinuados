#Include "Protheus.ch"
#INCLUDE "Topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CPAPUICMS   � Autor �Carlos Torres   � Data �  18/05/2016   ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza campos de T�tulos a Pagar na Apura��o de ICMS     ���
���          � 										 	                    ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CPAPUICMS()
Local cTfAlias := PARAMIXB[1] //Alias da tabela
Local cMV_PrefGNRE:= GETNEWPAR("MV_PFAPUIC","")

While At('"',cMV_PrefGNRE) != 0
	cMV_PrefGNRE := Stuff( cMV_PrefGNRE , At('"',cMV_PrefGNRE),1,'' )	
End

If CEMPANT="03" .AND. CFILANT="02" .AND. ALLTRIM((cTfAlias)->E2_TIPO)="TX" .AND. (cTfAlias)->E2_PREFIXO = ALLTRIM(cMV_PrefGNRE) 
	(cTfAlias)->E2_TIPO   := ALLTRIM((cTfAlias)->E2_TIPO) + LEFT(ALLTRIM(SF2->F2_SERIE),1)
	
	If !SX5->(DbSeek( xFilial("SX5") + "05" + (cTfAlias)->E2_TIPO ))
		SX5->(Reclock("SX5",.T.))
		SX5->X5_FILIAL	:= xFilial("SX5")
		SX5->X5_TABELA	:=	"05"
		SX5->X5_CHAVE	:= (cTfAlias)->E2_TIPO 
		SX5->X5_DESCRI	:= "Titulo de Taxas Nfe serie " + LEFT(ALLTRIM(SF2->F2_SERIE),1)
		SX5->X5_DESCSPA:= "Titulo de Taxas Nfe serie " + LEFT(ALLTRIM(SF2->F2_SERIE),1)
		SX5->X5_DESCENG:= "Titulo de Taxas Nfe serie " + LEFT(ALLTRIM(SF2->F2_SERIE),1)
		SX5->(MsUnlock())
	EndIf
	
EndIf
Return .T.