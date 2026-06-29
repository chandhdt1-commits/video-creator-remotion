import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import { render } from '@remotion/renderer';
import chalk from 'chalk';

/**
 * Video Creator using Remotion
 * CLI tool to create videos with voice over
 */

interface VideoCreatorOptions {
  topic: string;
  duration: number;
  language: string;
  outputDir: string;
  backgroundColor?: string;
  accentColor?: string;
  fps?: number;
  resolution?: [number, number];
}

class RemotionVideoCreator {
  private options: VideoCreatorOptions;

  constructor(options: VideoCreatorOptions) {
    this.options = {
      fps: 60,
      resolution: [1920, 1080],
      backgroundColor: '#0a0e27',
      accentColor: '#00d4ff',
      ...options,
    };
    this.ensureDirectories();
  }

  /**
   * Create necessary directories
   */
  private ensureDirectories(): void {
    [this.options.outputDir, 'temp_audio', 'videos/output'].forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(chalk.green(`✓ Created directory: ${dir}`));
      }
    });
  }

  /**
   * Generate speech using gTTS
   */
  async generateVoiceOver(): Promise<string> {
    console.log(chalk.blue('🎙️  Generating voice over...'));

    const script = `
      Xin chào! Hôm nay chúng ta sẽ tìm hiểu về ${this.options.topic}.
      ${this.options.topic} là một chủ đề rất thú vị và có nhiều ứng dụng thực tiễn.
      Cảm ơn bạn đã xem video. Hãy subscribe để nhận thêm nhiều video hay!
    `;

    const audioPath = path.join('temp_audio', `voice_${Date.now()}.mp3`);

    try {
      // Using gTTS-python wrapper or similar
      const command = `gtts-cli "${script.trim()}" --lang ${this.options.language} --file "${audioPath}"`;
      execSync(command, { stdio: 'inherit' });
      console.log(chalk.green(`✓ Voice over generated: ${audioPath}`));
      return audioPath;
    } catch (error) {
      console.log(chalk.yellow('⚠️  Voice generation skipped. Install gtts-cli or use pre-recorded audio.'));
      return '';
    }
  }

  /**
   * Render video using Remotion
   */
  async renderVideo(audioPath: string): Promise<string> {
    console.log(chalk.blue('🎬 Rendering video with Remotion...'));

    const outputPath = path.join(
      this.options.outputDir,
      `video_${this.options.topic.replace(/\s+/g, '_')}_${Date.now()}.mp4`
    );

    try {
      const durationInFrames = (this.options.duration * (this.options.fps || 60));

      // Remotion render API
      await render({
        composition: 'video-with-audio',
        serveUrl: 'http://localhost:3000',
        codec: 'h264',
        crf: 18,
        fps: this.options.fps || 60,
        height: this.options.resolution?.[1] || 1080,
        width: this.options.resolution?.[0] || 1920,
        durationInFrames,
        outputLocation: outputPath,
        inputProps: {
          topic: this.options.topic,
          duration: this.options.duration,
          backgroundColor: this.options.backgroundColor,
          accentColor: this.options.accentColor,
          audioPath: audioPath || undefined,
          textColor: '#ffffff',
        },
      });

      console.log(chalk.green(`✓ Video rendered: ${outputPath}`));
      return outputPath;
    } catch (error) {
      console.error(chalk.red('✗ Rendering failed:'), error);
      throw error;
    }
  }

  /**
   * Create video end-to-end
   */
  async create(): Promise<string> {
    try {
      console.log(chalk.cyan.bold('🎯 Starting Video Creation Process'));
      console.log(chalk.gray(`Topic: ${this.options.topic}`));
      console.log(chalk.gray(`Duration: ${this.options.duration}s`));
      console.log(chalk.gray(`Language: ${this.options.language}`));
      console.log(chalk.gray('─'.repeat(50)));

      // Step 1: Generate voice over
      const audioPath = await this.generateVoiceOver();

      // Step 2: Render video
      const videoPath = await this.renderVideo(audioPath);

      // Step 3: Cleanup
      this.cleanup();

      console.log(chalk.gray('─'.repeat(50)));
      console.log(chalk.cyan.bold('✅ Video Creation Completed Successfully!'));
      console.log(chalk.green(`📁 Output: ${videoPath}`));

      return videoPath;
    } catch (error) {
      console.error(chalk.red('✗ Video creation failed:'), error);
      throw error;
    }
  }

  /**
   * Cleanup temporary files
   */
  private cleanup(): void {
    console.log(chalk.blue('🧹 Cleaning up temporary files...'));
    try {
      if (fs.existsSync('temp_audio')) {
        fs.rmSync('temp_audio', { recursive: true });
        console.log(chalk.green('✓ Temp audio cleaned'));
      }
    } catch (error) {
      console.warn(chalk.yellow('⚠️  Cleanup warning:'), error);
    }
  }
}

/**
 * CLI Entry Point
 */
async function main() {
  const args = process.argv.slice(2);
  const topic = args[0] || 'Công nghệ';
  const duration = parseInt(args[1]) || 60;
  const language = args[2] || 'vi';

  const creator = new RemotionVideoCreator({
    topic,
    duration,
    language,
    outputDir: './videos/output',
    backgroundColor: '#0a0e27',
    accentColor: '#00d4ff',
  });

  const videoPath = await creator.create();
  console.log(chalk.cyan(`\n📹 Video saved to: ${videoPath}`));
}

main().catch((error) => {
  console.error(chalk.red('Fatal error:'), error);
  process.exit(1);
});
