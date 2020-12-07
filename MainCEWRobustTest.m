KeySeed = 500;
% proposedalgo: use 2093 data
OriShapeFilePath = 'Data\Ë®Ó¡ÈÝÁ¿ºÍÂ³°ôÐÔ²âÊÔ\Â³°ôÐÔ±¾Ëã·¨\pt_road2093.shp';
CEWShapeFilePath = 'Data\Ë®Ó¡ÈÝÁ¿ºÍÂ³°ôÐÔ²âÊÔ\Â³°ôÐÔ±¾Ëã·¨\OurMethodEncrypted\pt_road2093.shp';
AttackedShapeFilePath = 'Data\Ë®Ó¡ÈÝÁ¿ºÍÂ³°ôÐÔ²âÊÔ\Â³°ôÐÔ±¾Ëã·¨\OurMethodEncrypted\at_road2093.shp';
DecryptedShapeFilePath = 'Data\Ë®Ó¡ÈÝÁ¿ºÍÂ³°ôÐÔ²âÊÔ\Â³°ôÐÔ±¾Ëã·¨\OurMethodDecrypted\pt_road2093.shp';
OriWatermarkImage = '64bitwatermark.bmp';
ExtractedWMImage = 'Data\Ë®Ó¡ÈÝÁ¿ºÍÂ³°ôÐÔ²âÊÔ\Â³°ôÐÔ±¾Ëã·¨\ExtractedWatermark.bmp';
% REncryptLength = 0.004;
REncryptLength = 0.004;
RWatermarkLength = 1e-7;
% AEncryptLength = pi/400;
AEncryptLength = pi/400;
AWatermarkLength = 1e-7;
clear matrixcr;
j=1;
for attackstrength = 0:0.05:0.8
    clear creachattack;
    for i=1:2
%         [CEWedShapeFile,EmbedRecord] =
%         OPDeleteRandom(CEWShapeFilePath,AttackedShapeFilePath,attackstrength);
%         [CEWNC,WatermarkNC,ExtractedRecord]=CEWExtractAndDecrypt(KeySeed,AttackedShapeFilePath,DecryptedShapeFilePath,OriShapeFilePath,OriWatermarkImage,ExtractedWMImage,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength);
%         creachattack(i) = CompareWatermarkRecord(EmbedRecord,ExtractedRecord);
        creachattack(i) =  CEWRobustTest(KeySeed,OriShapeFilePath,CEWShapeFilePath,OriWatermarkImage,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength,attackstrength);
    end
    matrixcr(j)=mean(creachattack);
    j=j+1;
end