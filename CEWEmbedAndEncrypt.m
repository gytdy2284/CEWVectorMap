function [ CEWshp,EmbedWatermarkRecord] = CEWEmbedAndEncrypt(keyTransMatrix,orishappath,cewshppath,WatermarkImageFilePath,REncryptLength,RWatermarkLength,AEncryptLength,AWatermarkLength)
MaxKeyLength = 1000000;
% rng(keyseed);
% keylimit = 100;
% RKeyArray=randi([-keylimit,keylimit],1,MaxKeyLength);
% rng(keyseed+1);
% AKeyArray = randi([-keylimit,keylimit],1,MaxKeyLength);
shpdata=shaperead(orishappath);
[WatermarkSequence,WatermarkLength] = ReadWatermarkImage(WatermarkImageFilePath);
EmbedWatermarkRecord = zeros(WatermarkLength,2);
fileID=fopen('embedrec.txt','w');
WatermarkCapacityCount = 0;


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
    keyIndex = 1;
    for j=2:ptcount-1
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
        CurOID = OIDArray(j);
        RKey = keyTransMatrix(CurOID);
%         keyIndex = keyIndex + 1;
        EncryptedR=R*exp(RKey*REncryptLength);
        [CEWR, EmbedWatermarkRecord] = EmbedCEWWatermarkInDistanceRatio(fileID,EncryptedR,REncryptLength,RWatermarkLength,WatermarkSequence,WatermarkLength,EmbedWatermarkRecord);
        WatermarkCapacityCount = WatermarkCapacityCount + 1;
        
        CEWR = EncryptedR;
        
        AKey = keyTransMatrix(CurOID);
%         keyIndex = keyIndex + 1;
        EncryptedA=mod(A+pi+AKey*AEncryptLength,2*pi)-pi;
        [CEWA,EmbedWatermarkRecord] = EmbedCEWWatermarkInAngle(fileID,EncryptedA,AEncryptLength,AWatermarkLength,WatermarkSequence,WatermarkLength,EmbedWatermarkRecord);
        WatermarkCapacityCount = WatermarkCapacityCount + 1;
        
        CEWA = EncryptedA;
        fprintf(fileID,'R:%18.15f RKey:%18.15f EncryptedR:%18.15f CEWR:%18.15f A:%18.15f AKey:%18.15f EncryptedA:%18.15f CEWA::%18.15f\r\n',R,RKey,EncryptedR,CEWR,A,AKey,EncryptedA,CEWA);
        
        deltaA=CEWA-A;
        Encryptedx3=x2+((x3-x2)*cos(deltaA)-(y3-y2)*sin(deltaA))*CEWR/R;
        Encryptedy3=y2+((y3-y2)*cos(deltaA)+(x3-x2)*sin(deltaA))*CEWR/R;

        xarray(j+1)=Encryptedx3;
        yarray(j+1)=Encryptedy3;
%         ReCalculatedA = CalculateAngle(x1,y1,x2,y2,Encryptedx3,Encryptedy3);
%         ReCalculatedR = CalculateDistanceRatio(x1,y1,x2,y2,Encryptedx3,Encryptedy3);
%         fprintf(fileID,'ReCalculatedR:%18.15f  ReCalculatedA:%18.15f\r\n',ReCalculatedR,ReCalculatedA);
%         fprintf(fileID,'Orix3:%18.15f  Oriy3:%18.15f\r\n',x3,y3);
%         fprintf(fileID,'Encryptedx3:%18.15f  Encryptedy3:%18.15f\r\n',Encryptedx3,Encryptedy3);
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
CEWshp=shpdata;
shapewrite(shpdata,cewshppath);
WatermarkCapacityCount;
end

