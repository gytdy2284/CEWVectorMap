KeySeed = 500;
% proposedalgo: use 2093 data
OriShapeFilePath = 'Data\ˮӡ������³���Բ���\³���Ա��㷨\pt_road2093.shp';
CEWShapeFilePath = 'Data\ˮӡ������³���Բ���\³���Ա��㷨\OurMethodEncrypted\pt_road2093.shp';
AttackedShapeFilePath = 'Data\ˮӡ������³���Բ���\³���Ա��㷨\OurMethodEncrypted\at_road2093.shp';
DecryptedShapeFilePath = 'Data\ˮӡ������³���Բ���\³���Ա��㷨\OurMethodDecrypted\pt_road2093.shp';
OriWatermarkImage = '64bitwatermark.bmp';
ExtractedWMImage = 'Data\ˮӡ������³���Բ���\³���Ա��㷨\ExtractedWatermark.bmp';
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