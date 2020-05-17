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
                File tileFile = new File(line);
                TileConverter converter = new TileConverter(tileFile);
                String filename = line.substring(0, line.indexOf("."));
                converter.writeTiles(filename + "_tle.inc");
                converter.writeInfo(filename + "_info.txt");
                converter.writePal(filename + "_pal.inc");
                line = reader.readLine();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}
