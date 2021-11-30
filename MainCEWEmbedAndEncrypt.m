% KeySeed = 1224;
%jiaxing
% KeySeed = 5002;
% OriShapeFilePath = 'Data\ผฮะห\jiaxingcity.shp';
% CEWShapeFilePath = 'Data\ผฮะห\CEWWrongEncrypted3\StAlbans.shp';
% DecryptedShapeFilePath = 'Data\StAlbans\CEWDecrypted\StAlbans.shp';
folderName = 'StAlbans';
shapeNameNoExt = 'StAlbans';
shapeName = strcat(shapeNameNoExt,'.shp');
% keyFilePath = append('Data\',folderName,'\',shapeNameNoExt,'.mat');
keyFilePath = append('Data\',folderName,'\','wrongkey2',shapeNameNoExt,'.mat');
load(keyFilePath);
OriShapeFilePath = append('Data\',folderName,'\',shapeName);
% CEWShapeFilePath = append('Data\',folderName,'\CEWEncrypted\',shapeName);
CEWShapeFilePath = append('Data\',folderName,'\CEWWrongEncrypted2\',shapeName);
% DecryptedShapeFilePath = append('Data\',folderName,'\CEWDecrypted\',shapeName);
DecryptedShapeFilePath = append('Data\',folderName,'\CEWWrongDecrypted2\',shapeName);
OriWatermarkImage = 'Data\mark32.bmp';
% ExtractedWMImage = append('Data\',folderName,'\CEWDecrypted\ExtractedWatermark.bmp');
ExtractedWMImage = append('Data\',folderName,'\CEWWrongDecrypted2\ExtractedWatermark.bmp');
% ExtractedWMImage = 'Data\StAlbans\ExtractedWatermark.bmp';
% REncryptLength = 0.004;
REncryptLength = 0.004;
RWatermarkLength = 1e-7;
% AEncryptLength = pi/400;
AEncryptLength = pi/400;
AWatermarkLength = 1e-7;

[CEWedShapeFile,EmbedRecord] = CEWEmbedAndEncrypt(keyTransMatrix,OriShapeFilePath,CEWShapeFilePath,OriWatermarkImage,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength);
[CEWNC,WatermarkNC,ExtractedRecord]=CEWExtractAndDecrypt(keyTransMatrix,CEWShapeFilePath,DecryptedShapeFilePath,OriShapeFilePath,OriWatermarkImage,ExtractedWMImage,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength);
WatermarkCorrectRatio = CompareWatermarkRecord(EmbedRecord,ExtractedRecord)