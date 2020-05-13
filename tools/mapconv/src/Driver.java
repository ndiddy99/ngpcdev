import java.io.File;

public class Driver {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: mapconv map.tmx info.txt");
            return;
        }
        File mapFile = new File(args[0]);
        File infoFile = new File(args[1]);
        Map map = new Map(mapFile, infoFile);
        map.outputMap("map.inc");
    }
}
