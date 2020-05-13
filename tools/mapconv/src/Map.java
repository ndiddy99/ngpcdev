import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.*;
import java.util.HashMap;
import java.util.Scanner;

public class Map {
    private int[][] mapArr;
    private HashMap<Integer, Integer> palettes;

    public Map(File mapFile, File infoFile) {
        //set up map array
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = null;
        Document mapDocument = null;
        try {
            db = dbf.newDocumentBuilder();
            mapDocument = db.parse(mapFile);
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
        mapDocument.getDocumentElement().normalize();
        Element map = mapDocument.getDocumentElement();
        System.out.println(map.getNodeName());
        int width = Integer.parseInt(map.getAttribute("width"));
        int height = Integer.parseInt(map.getAttribute("height"));
        System.out.println("width: " + width);
        System.out.println("height: " + height);
        Element layer = (Element) map.getElementsByTagName("layer").item(0);
        Element data = (Element) layer.getElementsByTagName("data").item(0);
        String mapStr = data.getTextContent();
        mapArr = new int[height][width];
        Scanner scanner = new Scanner(mapStr);
        int rowCount = 0;
        while (scanner.hasNext()) {
            String line = scanner.nextLine();
            while (line.equals("") && scanner.hasNext()) {
                line = scanner.nextLine();
            }
            String[] elements = line.split(",");
            for (int i = 0; i < elements.length; i++) {
                if (!elements[i].equals("")) {
                    //tiled stores map elements 1 indexed
                    mapArr[rowCount][i] = Integer.parseUnsignedInt(elements[i]) - 1;
                }
            }
            rowCount++;
            if (rowCount == height) {
                break;
            }
        }
//        for (int i = 0; i < height; i++) {
//            for (int j = 0; j < width; j++) {
//                System.out.print(mapArr[i][j] + " ");
//            }
//            System.out.println();
//        }
        scanner.close();

        //set up palette hashmap
        BufferedReader reader = null;
        palettes = new HashMap<>();
        try {
            reader = new BufferedReader(new FileReader(infoFile));
            String line = reader.readLine();
            int palNum = 0;
            while (line != null) {
                String[] indices = line.split(" ");
                for (int i = 0; i < indices.length; i++) {
                    palettes.put(Integer.parseUnsignedInt(indices[i]), palNum);
                }
                line = reader.readLine();
                palNum++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void outputMap(String filename) {
        try {
            int outCount = 0;
            PrintWriter writer = new PrintWriter(filename);
            writer.print("\tdw ");
            for (int i = 0; i < mapArr.length; i++) {
                for (int j = 0; j < mapArr[0].length; j++) {
                    int mapVal = (mapArr[i][j] & 0x1ff);
                    int palette = palettes.get(mapVal);
                    mapVal |= ((palette & 0xf) << 9);
                    //is tile horizontally flipped?
                    if ((mapArr[i][j] & 0x80000000) == 0x80000000) {
                        mapVal |= 0x8000;
                    }
                    //is tile vertically flipped?
                    if ((mapArr[i][j] & 0x40000000) == 0x40000000) {
                        mapVal |= 0x4000;
                    }
                    if (outCount == 8) {
                        writer.print("\tdw ");
                        outCount = 0;
                    }
                    if (outCount == 7) {
                        writer.println(String.format("0x%04X", mapVal));;
                    }
                    else {
                        writer.print(String.format("0x%04X,", mapVal));
                    }
                    outCount++;
                }
            }
            writer.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
