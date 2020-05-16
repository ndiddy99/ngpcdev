import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.ColorModel;
import java.awt.image.IndexColorModel;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;

public class TileConverter {
    private ArrayList<Byte> tileData;
    private Palette[] palettes;
    final int PALETTE_SIZE = 3;
    final int NUM_PALETTES = 16;
    private int width;
    private int height;
    private BufferedImage image;
    private IndexColorModel colorModel;
    private byte[] reds;
    private byte[] greens;
    private byte[] blues;

    public TileConverter(File bmpFile) {
        tileData = new ArrayList<>();
        palettes = new Palette[NUM_PALETTES];
        int paletteCursor = 0;
        try {
            image = ImageIO.read(bmpFile);
            if (image.getColorModel() instanceof IndexColorModel) {
                colorModel = (IndexColorModel) image.getColorModel();
            } else {
                System.out.println("ERROR: Image not indexed color");
                return;
            }
            int numCols = colorModel.getMapSize();
            reds = new byte[numCols];
            colorModel.getReds(reds);
            greens = new byte[numCols];
            colorModel.getGreens(greens);
            blues = new byte[numCols];
            colorModel.getBlues(blues);

            width = image.getWidth();
            height = image.getHeight();
            //split image up into 8x8 tiles
            int[] imageData = new int[8 * 8];
            for (int i = 0; i < height; i += 8) {
                for (int j = 0; j < width; j += 8) {
                    imageData = image.getData().getPixels(j, i, 8, 8, imageData);
                    int[] colors = new int[PALETTE_SIZE];
                    int colorCursor = 0;
                    //validate tile
                    for (int k = 0; k < imageData.length; k++) {
                        if ((imageData[k] & 0xff) != 0) { //if not the background color
                            boolean colorExists = false;
                            for (int l = 0; l < colors.length; l++) {
                                if (colors[l] == imageData[k]) {
                                    colorExists = true;
                                }
                            }
                            if (!colorExists) {
                                if (colorCursor == 3) {
                                    System.out.println("ERROR: Too many colors in tile at " + j + ", " + i);
                                    return;
                                }
                                colors[colorCursor++] = imageData[k];
                            }
                        }
                    }
                    Arrays.sort(colors);
                    Palette colorPal = new Palette(colors);
                    boolean inArr = false;
                    for (int k = 0; k < paletteCursor; k++) {
                        if (palettes[k].superset(colorPal)) {
                            palettes[k].addTile((i / 8) * (width / 8) + (j / 8));
                            inArr = true;
                            break;
                        }
                        else if (colorPal.superset(palettes[k])) {
                            int[] tiles = palettes[k].getTileList();
                            for (int l = 0; l < tiles.length; l++) {
                                colorPal.addTile(tiles[l]);
                            }
                            colorPal.addTile((i / 8) * (width / 8) + (j / 8));
                            palettes[k] = colorPal;
                            inArr = true;
                            break;
                        }
                    }
                    if (!inArr) {
                        if (paletteCursor == 16) {
                            System.out.println("ERROR: Too many palettes (Max 16)");
                            return;
                        }
                        colorPal.addTile((i / 8) * (width / 8) + (j / 8));
                        palettes[paletteCursor++] = colorPal;
                    }

                    for (int k = 0; k < imageData.length; k++) {
                        tileData.add((byte) (imageData[k] & 0xFF));

                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private int indexToColor(int index) {
//        System.out.println(index + ": " + (reds[index] & 0xff) + ", " + (greens[index] & 0xff) + ", " + (blues[index] & 0xff));
        return ((reds[index] & 0xff) >> 4) | (((greens[index] & 0xff) >> 4) << 4) | (((blues[index] & 0xff) >> 4) << 8);
    }

    public void writePal(String filename) {
        try {
            PrintWriter writer = new PrintWriter(filename, "UTF-8");
            for (int i = 0; i < palettes.length; i++) {
                if (palettes[i] != null) {
                    int[] colors = palettes[i].getColors();
                    writer.print("\tdb 0x00,0x00,");
//                    System.out.println("Palette " + i);
                    for (int j = 0; j < colors.length; j++) {
                        int currColor = indexToColor(colors[j]);
                        if (j == colors.length - 1) {
                            writer.println(String.format("0x%02X,0x%02X", currColor & 0xFF, (currColor & 0xFF00) >> 8));
                        }
                        else {
                            writer.print(String.format("0x%02X,0x%02X,", currColor & 0xFF, (currColor & 0xFF00) >> 8));
                        }
                    }
                }
            }
            writer.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void writeInfo(String filename) {
        try {
            PrintWriter writer = new PrintWriter(filename, "UTF-8");
            for (int i = 0; i < palettes.length; i++) {
                if (palettes[i] != null) {
                    int[] tileList = palettes[i].getTileList();
                    for (int j = 0; j < tileList.length; j++) {
                        if (j == tileList.length - 1) {
                            writer.println(tileList[j]);
                        }
                        else {
                            writer.print(tileList[j] + " ");
                        }
                    }
                }
            }
            writer.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    private int getPalette(int tileNum, int index) {
        if (index == 0) {
            return 0;
        }
        for (int i = 0; i < palettes.length; i++) {
            if (palettes[i] != null) {
                int[] tileList = palettes[i].getTileList();
                for (int j = 0; j < tileList.length; j++) {
                    if (tileList[j] == tileNum) {
                        int[] colors = palettes[i].getColors();
                        for (int k = 0; k < colors.length; k++) {
                            if (colors[k] == index) {
                                return k + 1; //0 is the bg color, palettes start @ 1
                            }
                        }
                    }
                }
            }
        }
        return 0;
    }

    public void writeTiles(String filename) {
        try {
            PrintWriter writer = new PrintWriter(filename, "UTF-8");
            writer.print("\tdb ");
            for (int i = 0; i < tileData.size(); i += 8) {
                int byte1 = 0;
                int byte2 = 0;
                for (int j = 0; j < 4; j++) {
                    int pixel = getPalette(i / 64, tileData.get(i + j));
                    byte2 <<= 2;
                    byte2 |= (pixel & 0x3);
                }
                for (int j = 4; j < 8; j++) {
                    int pixel = getPalette(i / 64, tileData.get(i + j));
                    byte1 <<= 2;
                    byte1 |= (pixel & 0x3);
                }
                if (i > 0 && i % 64 == 0) {
                    writer.print("\tdb ");
                }
                if (i % 64 == 56) {
                    writer.println(String.format("0x%02X,0x%02X", byte1 & 0xFF, byte2 & 0xFF));
                }
                else {
                    writer.print(String.format("0x%02X,0x%02X,", byte1 & 0xFF, byte2 & 0xFF));
                }
            }
            writer.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
