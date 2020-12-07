function [CryptographyNC, WatermarkNC, ExtractedWatermarkRecord] = CEWExtractAndDecrypt(KeySeed,CEWShapeFilePath,DecryptedShapeFilePath,OriShapeFilePath,OriWatermarkImageFilePath,ExtractedWatermarkImageFilePath,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
MaxKeyLength = 1000000;
rng(KeySeed);
keylimit = 100;
RKeyArray=randi([-keylimit,keylimit],1,MaxKeyLength);
rng(KeySeed+1);
AKeyArray = randi([-keylimit,keylimit],1,MaxKeyLength);
shpdata=shaperead(CEWShapeFilePath);

[OriWatermarkSequence,OriWatermarkLength,ImageHeigth,ImageWidth] = ReadWatermarkImage(OriWatermarkImageFilePath);
ExtractedWatermarkRecord = zeros(OriWatermarkLength,2);
fileID=fopen('extractrec.txt','w');
% [row,col]=size(wmimg);
% binwmlength=row*col;
% base=floor(log2(intervalcount));
% [wmseq,wmseqlength]=Convertfrombinary(wm,base,binwmlength);

if strcmp(shpdata(1).Geometry,'Line') || strcmp(shpdata(1).Geometry,'Point') || strcmp(shpdata(1).Geometry,'Polygon')
    xallarray=[shpdata(:).X];
    yallarray=[shpdata(:).Y];
%     OIDAllArray = [shpdata(:).OBJECTID];
    xnotnanindex=find(~isnan(xallarray));
    ynotnanindex=find(~isnan(yallarray));
    xarray=xallarray(xnotnanindex);
    yarray=yallarray(ynotnanindex);
    
    ptcount=numel(xarray);
    OIDArray = 1:ptcount;
%     for j=2:ptcount-1
    for j=ptcount-1:-1:2
        x1=xarray(j-1);
        x2=xarray(j);
        x3=xarray(j+1);
        y1=yarray(j-1);
        y2=yarray(j);
        y3=yarray(j+1);
        
        A=CalculateAngle(x1,y1,x2,y2,x3,y3);
        if ~isreal(A)
            continue;
        end
        if isnan(A)
            continue;
        end
        R = CalculateDistanceRatio(x1,y1,x2,y2,x3,y3);
        if ~isreal(R)
            continue;
        end
        if isnan(R)
            continue;
        end
        [WatermarkBitIndex,WatermarkBit] = ExtractCEWWatermarkFromDistanceRatio(fileID,R,REncryptLength,RWatermarkLength,OriWatermarkLength);
        ExtractedWatermarkRecord(WatermarkBitIndex,WatermarkBit+1)=ExtractedWatermarkRecord(WatermarkBitIndex,WatermarkBit+1) + 1;
         
        CurOID = OIDArray(j);
        RKey = RKeyArray(CurOID);
        DecryptedR=R*exp(-RKey*REncryptLength);
        deltaR=DecryptedR-R;
        
        [WatermarkBitIndex,WatermarkBit] = ExtractCEWWatermarkFromAngle(fileID,A,AEncryptLength,AWatermarkLength,OriWatermarkLength);
        ExtractedWatermarkRecord(WatermarkBitIndex,WatermarkBit+1)=ExtractedWatermarkRecord(WatermarkBitIndex,WatermarkBit+1) + 1;
        AKey = AKeyArray(CurOID);
        DecryptedA=mod(A+pi-AKey*AEncryptLength,2*pi)-pi;

%         fprintf(fileID,'ExtractedR:%18.15f RKey:%18.15f DecryptedR:%18.15f ExtractedA:%18.15f AKey:%18.15f DecryptedA:%18.15f\r\n',R,RKey,DecryptedR,A,AKey,DecryptedA);
        deltaA=DecryptedA-A;
        Encryptedx3=x2+((x3-x2)*cos(deltaA)-(y3-y2)*sin(deltaA))*DecryptedR/R;
        Encryptedy3=y2+((y3-y2)*cos(deltaA)+(x3-x2)*sin(deltaA))*DecryptedR/R;
%old         fprintf(fileID,'R:%18.15f EncryptedR:%18.15f A:%18.15f EncryptedA:%18.15f\r\n',R,EncryptedR,A,EncryptedA);
%old         fprintf(fileID,'x3:%18.15f y3:%18.15f Encryptedx3:%18.15f Encryptedy3:%18.15f\r\n',x3,y3,Encryptedx3,Encryptedy3);
%         fprintf(fileID,'Extractedx3:%18.15f  Extractedy3:%18.15f\r\n',x3,y3);
%         fprintf(fileID,'Decryptedx3:%18.15f  Decryptedy3:%18.15f\r\n',Encryptedx3,Encryptedy3);
        xarray(j+1)=Encryptedx3;
        yarray(j+1)=Encryptedy3;
    end
    xallarray(xnotnanindex)=xarray;
    yallarray(ynotnanindex)=yarray;
    indexx = 1;
    for i=1:numel(shpdata)
        curline=shpdata(i);
        temparray=curline.X;
        ptcount=numel(temparray);
        for j=1:ptcount
            curline.X(j)=xallarray(indexx);
            curline.Y(j)=yallarray(indexx);
            indexx = indexx + 1;
        end
        shpdata(i).X=curline.X;
        shpdata(i).Y=curline.Y;
    end
        
end
fclose(fileID);

shapewrite(shpdata,DecryptedShapeFilePath);

[max_count,max_index]=max(ExtractedWatermarkRecord,[],2);
ExtractedWatermark=max_index-1;
%use embedinfo

%use embedinfo
RightCount=0;
for i=1:OriWatermarkLength
    if(ExtractedWatermark(i)==OriWatermarkSequence(i))
        RightCount = RightCount + 1;
    end
end
WatermarkNC=RightCount/OriWatermarkLength;
eximg=ExtractedWatermark(1:OriWatermarkLength);
eximg=reshape(eximg,[ImageHeigth,ImageWidth]);
eximg=1-eximg;
% imshow(eximg);
imwrite(eximg,ExtractedWatermarkImageFilePath);
% [DistanceMean,DistanceVar] = CompareShapefileDifference(OriShapeFilePath,DecryptedShapeFilePath);
% if DistanceMean < 0.00000000000001
%     CryptographyNC = 1;
% else
%     CryptographyNC = 1-DistanceMean/1;
% end
CryptographyNC=1;


