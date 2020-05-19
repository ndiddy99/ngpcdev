import java.util.ArrayList;

public class Palette {
    private int[] colors;
    private ArrayList<Integer> tiles;

    public Palette(int[] palette) {
        colors = palette;
        tiles = new ArrayList<>();
    }

    public int[] getColors() {
        return colors;
    }

    public void addTile(int tileNum) {
        tiles.add(tileNum);
    }

    public int[] getTileList() {
        int[] array = new int[tiles.size()];
        for (int i = 0; i < tiles.size(); i++) {
            array[i] = tiles.get(i);
        }
        return array;
    }

    public boolean superset(Palette otherPalette) {
        int[] otherColors = otherPalette.getColors();
        for (int i = 0; i < otherColors.length; i++) {
            int j;
            if (otherColors[i] == 0) { //background color isn't shown anyway
                continue;
            }
            for (j = 0; j < colors.length; j++) {
                if (otherColors[i] == colors[j]) {
                    break;
                }
            }
            if (j == colors.length) {
                return false;
            }
        }
        return true;
    }

}
