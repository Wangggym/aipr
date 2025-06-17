use clap::Parser;
use async_openai::{
    config::OpenAIConfig,
    types::{
        CreateChatCompletionRequestArgs,
        ChatCompletionRequestMessage,
        ChatCompletionRequestUserMessage,
        ChatCompletionRequestUserMessageContent,
    },
    Client,
};

/// PR Title Translator: 将 PR 标题翻译成英文
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// 需要翻译的 PR 标题
    #[arg(long)]
    title: String,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let api_key = std::env::var("DEEPSEEK_KEY")?;
    let config = OpenAIConfig::new()
        .with_api_base("https://api.deepseek.com/v1")
        .with_api_key(api_key);
    let client = Client::with_config(config);

    let prompt = format!(
        "请将下列 Pull Request 标题翻译成英文，且只输出英文翻译：\n{}",
        Args::parse().title
    );

    let req = CreateChatCompletionRequestArgs::default()
        .model("deepseek-chat")
        .messages([ChatCompletionRequestMessage::User(
            ChatCompletionRequestUserMessage {
                content: ChatCompletionRequestUserMessageContent::Text(prompt),
                name: None,
            }
        )])
        .build()?;

    let resp = client.chat().create(req).await?;
    let translation = resp.choices[0].message.content.as_deref().unwrap_or("").trim();
    println!("英文翻译: {}", translation);
    Ok(())
}
