import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

public class Driver {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: tileconv [list].txt");
            return;
        }
        File listFile = new File(args[0]);
        BufferedReader reader;
        try {
            reader = new BufferedReader(new FileReader(listFile));
            String line = reader.readLine();
            while (line != null) {
                if (line.charAt(0) == 't') {
                    File tileFile = new File(line.substring(2));
                    TileConverter converter = new TileConverter(tileFile);
                    System.out.println("done constructor");
                    converter.writeTiles("tiles.inc");
                    System.out.println("tiles");
                    converter.writeInfo("info.txt");
                    converter.writePal("palette.inc");
                }
                line = reader.readLine();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}
