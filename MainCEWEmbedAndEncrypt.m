% KeySeed = 1224;
%jiaxing
KeySeed = 5002;
OriShapeFilePath = 'Data\StAlbans\StAlbans.shp';
CEWShapeFilePath = 'Data\StAlbans\CEWWrongEncrypted3\StAlbans.shp';
DecryptedShapeFilePath = 'Data\StAlbans\CEWDecrypted\StAlbans.shp';
OriWatermarkImage = 'Data\mark32.bmp';
ExtractedWMImage = 'Data\StAlbans\ExtractedWatermark.bmp';
% REncryptLength = 0.004;
REncryptLength = 0.004;
RWatermarkLength = 1e-7;
% AEncryptLength = pi/400;
AEncryptLength = pi/400;
AWatermarkLength = 1e-7;

[CEWedShapeFile,EmbedRecord] = CEWEmbedAndEncrypt(KeySeed,OriShapeFilePath,CEWShapeFilePath,OriWatermarkImage,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength);
[CEWNC,WatermarkNC,ExtractedRecord]=CEWExtractAndDecrypt(KeySeed,CEWShapeFilePath,DecryptedShapeFilePath,OriShapeFilePath,OriWatermarkImage,ExtractedWMImage,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength);
WatermarkCorrectRatio = CompareWatermarkRecord(EmbedRecord,ExtractedRecord)