#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DLVENDER  �Autor  �Edson Estevam       � Data �  06/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para ajustar a leitura do C�digo de barras ��
���          � do endere�o , cujo consta a informa��o Armazem + C�digo    ���
���          � O objetivo � que na rotina do WMS seja desconsiderado o Arm���
�������������������������������������������������������������������������͹��
���Uso       � Taiff                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DLVENDER()


Local _cConfUser := PARAMIXB[1] // C�DIGO DO ENDERE�O QUE FOI LIDO NO C�DIGO DE BARRAS pelo usuario (0201A4)         
Local _cEndereco := PARAMIXB[2] // C�DIGO DO ENDERE�O SOLICITADO PELO SISTEMA  ( EX 01A04)
Local _lRet      := .F.

If Len(Alltrim(_cConfUser)) > Len(Alltrim(_cEndereco)) //(LEN) CONSIDERA TODO OS ESPA�OS DO CAMPO DO ENDERE�O 

	_cConfUser := Substr(_cConfUser,3)+Space(2) // Ignora os dois primeiros caracter do C�digos de Barras 
    
     cConfirma := _cConfUser

	_lRet := ( _cConfUser == _cEndereco )
Endif
Return _lRet


