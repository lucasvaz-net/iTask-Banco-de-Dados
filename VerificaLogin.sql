
CREATE PROCEDURE [dbo].[VerificaLogin] CREATE PROCEDURE VerificaLogin
    @Email VARCHAR(100),
    @Senha VARCHAR(100),
    @IsValid BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ViewUsuario WHERE Email = @Email AND Senha = @Senha)
        SET @IsValid = 1;
    ELSE
        SET @IsValid = 0;
END;
CREATE PROCEDURE [dbo].[VerificarLoginSenha] -- Cria��o da stored procedure VerificarLoginSenha
CREATE PROCEDURE VerificarLoginSenha
    @email VARCHAR(100),
    @senha VARCHAR(100),
    @status INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM Usuario WHERE email = @email AND senha = @senha)
        SET @status = 1; -- Login v�lido
    ELSE
        SET @status = 0; -- Login inv�lido
END
;
